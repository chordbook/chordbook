json.id genre.to_param
json.extract! genre, :name, :thumbnail, :created_at, :updated_at
json.url api_genre_url(genre, format: :json)
