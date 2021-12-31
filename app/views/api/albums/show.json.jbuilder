json.partial! "api/albums/album", album: @album
json.extract! @album, :description, :metadata
json.artist do
  json.partial! "api/artists/artist", artist: @album.artist
end
json.tracks do
  json.array! @album.tracks, partial: "api/tracks/track", as: :track
end
