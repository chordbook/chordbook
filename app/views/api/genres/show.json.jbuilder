json.partial! "api/genres/genre", genre: @genre

json.artists do
  json.array! @genre.artists.limit(12), partial: "api/artists/artist", as: :artist
end
json.albums do
  json.array! @genre.albums.limit(12), partial: "api/albums/album", as: :album
end
json.tracks do
  json.array! @genre.tracks.limit(18), partial: "api/tracks/track", as: :track
end
