require "throttle"

class LookupMetadata < ApplicationJob
  include HTTParty
  API_KEY = ENV["THEAUDIODB_API_KEY"] || "2" # default public key
  base_uri "https://www.theaudiodb.com"
  raise_on 400..600
  queue_as :metadata

  delegate :get, :path, to: :class

  class_attribute :throttle, default: Throttle.new(2.5.seconds)

  def perform(artist_name, recursive: true, reassociate: nil)
    artists = Array(get("search.php", query: {s: artist_name})["artists"]).map do |data|
      reference = Reference.theaudiodb.find_or_initialize_by(identifier: data["idArtist"])
      reference.record ||= Artist.new

      # Save new data
      reference.update! data: data

      sync_artist_albums reference if recursive

      reference.record
    end

    # Run job to associate songsheet
    if reassociate && artists.length > 0
      AssociateSongsheetMetadata.perform_later(reassociate, lookup_unknown_artist: false)
    end

    artists
  end

  def sync_artist_albums(artist_ref, recursive: true)
    # Look up albums by artist id
    Array(get("album.php", query: {i: artist_ref.identifier})["album"]).each do |album_data|
      reference = Reference.theaudiodb.find_or_initialize_by(identifier: album_data["idAlbum"])
      reference.record ||= Album.new(artist: artist_ref.record)
      reference.update! data: album_data

      sync_tracks reference.record if recursive
    end
  end

  def sync_tracks(album)
    reference = Reference.theaudiodb.find_by!(record: album)

    response = get "track.php", query: {m: reference.identifier}
    response["track"].each do |track_data|
      track = album.tracks.find_or_create_by!(title: track_data["strTrack"], artist: album.artist)
      track_ref = track.theaudiodb_reference || track.build_theaudiodb_reference
      track_ref.update! identifier: track_data["idTrack"], data: track_data
    end
  end

  def self.get(path, *args)
    throttle.call do
      super("/api/v1/json/#{API_KEY}/#{path}", *args)
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
