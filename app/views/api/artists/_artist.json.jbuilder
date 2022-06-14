json.extract! artist, :id, :uid, :name, :thumbnail, :created_at, :updated_at
json.url api_artist_url(artist, format: :json)
