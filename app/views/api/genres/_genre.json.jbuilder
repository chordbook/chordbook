json.id genre.to_param
json.extract! genre, :name, :created_at, :updated_at
json.thumbnail variant_url(genre.image, :medium) if genre.image.attached?
json.url api_genre_url(genre, format: :json)
