json.partial! "api/albums/album", album: @album
json.extract! @album, :description, :metadata
json.artist do
  json.partial! @album.artist, shallow: true
end
json.tracks do
  json.array! @album.tracks, partial: "api/tracks/track", as: :track, shallow: true
end
