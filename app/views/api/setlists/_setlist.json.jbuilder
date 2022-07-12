json.id setlist.to_param
json.extract! setlist, :uid, :title, :description, :created_at, :updated_at
json.thumbnails setlist.thumbnails.map { |image| variant_url(image, :thumb) }
json.url api_setlist_url(setlist, format: :json)
