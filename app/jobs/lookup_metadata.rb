require "throttle"

class LookupMetadata < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency
  include HTTParty
  API_KEY = ENV["THEAUDIODB_API_KEY"] || "2" # default public key
  base_uri "https://www.theaudiodb.com"
  raise_on 400..600
  queue_as :metadata

  delegate :get, :path, to: :class

  class_attribute :throttle, default: Throttle.new(2.5.seconds)

  class Duplicate < StandardError
  end

  discard_on Duplicate

  def perform(model, recursive: true, **args)
    send "sync_#{model.class.name.underscore}", model, recursive: recursive, **args
  end

  def sync_artist(artist, recursive: true, metadata: nil)
    # No new metadata provided, look it up
    unless metadata
      response = if (id = artist.metadata["idArtist"])
        # Artist was previously synced, but lookup by known id to refresh
        get "artist.php", query: {i: id}
      else
        # New artist, search and use first result
        get "search.php", query: {s: artist.name}
      end

      metadata = Array(response["artists"]).first
    end

    # No need to continue if artist is unknown
    return unless metadata

    # Sanity check to ensure that this artist was not looked up while this job was waiting in the queue
    if Artist.where("metadata->>'idArtist' = ?", metadata["idArtist"]).where.not(id: artist.id).first
      artist.destroy
      raise Duplicate.new("#{artist.name} (#{metadata["idArtist"]}) is a duplicate")
    end

    # Save new metadata
    artist.update metadata: metadata, verified: true

    if recursive
      # Look up albums
      response = get "album.php", query: {i: metadata["idArtist"]}
      Array(response["album"]).each_with_index do |album_data, i|
        album = artist.albums.find_or_create_by!(title: album_data["strAlbum"]) do |a|
          a.metadata = album_data
        end

        # Album exists, update it with new metadata
        sync_album album, recursive: recursive, metadata: album_data
      end
    end
  end

  def sync_album(album, recursive: true, metadata: nil)
    unless metadata
      response = get "album.php", query: {i: album.artist.metadata["idArtist"]}
      metadata = response["album"].detect { |data| data["strAlbum"] == album.title }
    end

    album.update metadata: metadata

    if recursive
      response = get "track.php", query: {m: metadata["idAlbum"]}
      response["track"].each do |track_data|
        album.tracks.find_or_create_by!(title: track_data["strTrack"]) do |t|
          t.artist = album.artist
          t.metadata = track_data
        end
      end
    end
  end

  def self.get(path, *args)
    throttle.call do
      super "/api/v1/json/#{API_KEY}/#{path}", *args
    end
  end

  def self.trending
    get("trending.php?country=us&type=itunes&format=albums")["trending"].each do |trend|
      Artist.find_or_create_by!(name: trend["strArtist"])
    end
  end

  def self.most_loved
    %w[track album].each do |format|
      get("mostloved.php?format=#{format}")["loved"].each do |item|
        Artist.find_or_create_by!(name: item["strArtist"])
      end
    end
  end
end
