json.id artist.to_param
json.extract! artist, :uid, :name, :created_at, :updated_at
json.thumbnail variant_url(artist.image, :medium)
json.url api_artist_url(artist, format: :json)
