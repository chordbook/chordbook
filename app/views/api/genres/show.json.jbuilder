json.partial! "api/genres/genre", genre: @genre

json.artists do
  json.array! @genre.artists.limit(6), partial: "api/artists/artist", as: :artist
end
json.albums do
  json.array! @genre.albums.limit(6), partial: "api/albums/album", as: :album
end
json.tracks do
  json.array! @genre.tracks.order_by_popular.limit(12), partial: "api/tracks/track", as: :track
end
