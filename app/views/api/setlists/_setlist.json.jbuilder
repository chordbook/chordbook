json.id setlist.to_param
json.extract! setlist, :uid, :title, :description, :thumbnails, :created_at, :updated_at
json.url api_setlist_url(setlist, format: :json)
