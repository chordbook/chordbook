json.partial! "api/genres/genre", genre: @genre

json.tracks do
  json.array! @genre.tracks.order_by_popular.limit(12), partial: "api/tracks/track", as: :track
end
json.artists do
  json.array! @genre.artists.limit(10), partial: "api/artists/artist", as: :artist
end
