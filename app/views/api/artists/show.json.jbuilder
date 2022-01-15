json.partial! "api/artists/artist", artist: @artist
json.extract! @artist, :banner, :biography, :style, :metadata
json.genre { json.partial! "api/genres/genre", genre: @artist.genre } if @artist.genre
