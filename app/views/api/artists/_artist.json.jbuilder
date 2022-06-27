json.id artist.to_param
json.extract! artist, :uid, :name, :thumbnail, :created_at, :updated_at
json.url api_artist_url(artist, format: :json)
