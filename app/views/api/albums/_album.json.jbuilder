json.id album.to_param
json.extract! album, :uid, :title, :released, :genre, :style, :created_at, :updated_at
json.cover do
  json.small variant_url(album.image, :small)
  json.medium variant_url(album.image, :medium)
  json.large variant_url(album.image, :large)
end
json.artist do
  json.partial! "api/artists/artist", artist: album.artist
end
json.url api_artist_album_url(album.artist, album, format: :json)
