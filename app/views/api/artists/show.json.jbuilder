json.partial! "api/artists/artist", artist: @artist
json.extract! @artist, :banner, :biography, :genre, :style, :metadata
