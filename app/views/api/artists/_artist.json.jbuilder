json.id artist.to_param
json.extract! artist, :uid, :name, :created_at, :updated_at
json.thumbnail artist.image.attached? ? variant_url(artist.image, :thumb) : artist.thumbnail
json.url api_artist_url(artist, format: :json)
