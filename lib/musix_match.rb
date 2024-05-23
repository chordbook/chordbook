module MusixMatch
  extend self
  include HTTParty

  API_KEY = ENV["MUSIXMATCH_API_KEY"] || "test"

  base_uri "https://api.musixmatch.com"
  raise_on 400..600
  default_params apikey: API_KEY
  logger Rails.logger
  format :json

  def match_track(params = {})
    get "/ws/1.1/matcher.track.get", query: params
  end

  def track_lyrics(track_id)
    get "/ws/1.1/track.lyrics.get", query: {track_id: track_id}
  end

  def artist_search(params = {})
    get "/ws/1.1/artist.search", query: params
  end
end
