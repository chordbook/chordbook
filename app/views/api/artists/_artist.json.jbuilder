json.extract! artist, :id, :name, :thumbnail, :created_at, :updated_at
json.url api_artists_url(artist, format: :json)
