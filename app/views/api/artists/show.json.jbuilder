json.partial! "api/artists/artist", artist: @artist
json.extract! @artist, :biography, :style, :metadata
json.banner variant_url(@artist.banner, :banner) if @artist.banner.attached?
json.genre { json.partial! "api/genres/genre", genre: @artist.genre } if @artist.genre
