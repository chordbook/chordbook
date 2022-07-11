json.id genre.to_param
json.extract! genre, :name, :created_at, :updated_at
json.thumbnail genre.image.attached? ? variant_url(genre.image, :genre) : genre.thumbnail
json.url api_genre_url(genre, format: :json)
