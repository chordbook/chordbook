json.extract! track, :id, :title, :number, :duration, :has_songsheet, :created_at, :updated_at
json.album do
  json.partial! track.album, as: :album
end
json.artist do
  json.partial! track.artist, as: :artist
end
json.url api_artist_album_track_url(track.artist, track.album, track, format: :json)
