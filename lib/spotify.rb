module Spotify
  extend self
  include HTTParty

  CLIENT_ID = ENV["SPOTIFY_CLIENT_ID"] || "test"
  CLIENT_SECRET = ENV["SPOTIFY_CLIENT_SECRET"] || "test"

  # base_uri "https://api.musixmatch.com"
  raise_on 400..600
  # default_params apikey: API_KEY
  logger Rails.logger
  format :json

  def client_credential
    @client_credential ||= post "https://accounts.spotify.com/api/token",
      headers: { Authorization: "Basic " + Base64.strict_encode64("#{CLIENT_ID}:#{CLIENT_SECRET}") },
      body: { grant_type: "client_credentials" }
  end
end
