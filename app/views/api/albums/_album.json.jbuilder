json.extract! album, :id, :title, :thumbnail, :released, :genre, :style, :created_at, :updated_at
json.url api_artist_album_url(album.artist, album, format: :json)
