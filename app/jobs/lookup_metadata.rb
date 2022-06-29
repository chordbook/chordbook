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

  def perform(artist_name, recursive: true, reassociate: nil)
    artists = get("search.php", query: {s: artist_name})["artists"].map do |metadata|
      # Find artist with given external id
      artist = Artist.where("metadata->>'idArtist' = ?", metadata["idArtist"]).first_or_initialize

      # Save new metadata
      artist.update metadata: metadata

      sync_artist_albums artist if recursive

      artist
    end

    # Run job to associate songsheet
    AssociateSongsheetMetadata.perform_later(reassociate, lookup_unknown_artist: false) if reassociate

    artists
  end

  def sync_artist_albums(artist, recursive: true)
    # Look up albums by artist id
    response = get "album.php", query: {i: artist.metadata["idArtist"]}

    Array(response["album"]).each do |album_data|
      album = artist.albums.find_or_create_by!(title: album_data["strAlbum"]) do |a|
        a.metadata = album_data
      end

      # Album exists, update it with new metadata
      sync_album album, recursive: recursive, metadata: album_data
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
