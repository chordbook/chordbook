shallow ||= false

json.id album.to_param
json.type album.model_name
json.extract! album, :uid, :title, :released, :style, :created_at, :updated_at
json.cover do
  json.small variant_url(album.image, :small)
  json.medium variant_url(album.image, :medium)
  json.large variant_url(album.image, :large)
end
json.url api_artist_album_url(album.artist, album, format: :json)

unless shallow
  json.genre { json.partial! album.genre, shallow: true if album.genre }
  json.artist { json.partial! album.artist, shallow: true }
end
