json.id setlist.to_param
json.type setlist.model_name
json.extract! setlist, :uid, :title, :description, :created_at, :updated_at
json.user { json.partial! setlist.user, as: :user }
json.thumbnails setlist.thumbnails.map { |image| variant_url(image, :small) }
json.url api_setlist_url(setlist, format: :json)
