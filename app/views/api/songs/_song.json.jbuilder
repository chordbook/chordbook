json.extract! song, :id, :title, :subtitle, :created_at, :updated_at
json.url api_song_url(song, format: :json)
