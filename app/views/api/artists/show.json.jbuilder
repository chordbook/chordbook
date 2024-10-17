json.partial! @artist
json.extract! @artist, :biography, :style
json.banner variant_url(@artist.banner, :medium)
json.genre { json.partial! @artist.genre } if @artist.genre
