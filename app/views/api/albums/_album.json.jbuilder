variant ||= :thumb

json.id album.to_param
json.extract! album, :uid, :title, :released, :genre, :style, :created_at, :updated_at
json.thumbnail album.image.attached? ? variant_url(album.image, variant) : album.thumbnail
json.artist do
  json.partial! "api/artists/artist", artist: album.artist
end
json.url api_artist_album_url(album.artist, album, format: :json)
