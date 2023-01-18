shallow ||= false

json.id track.to_param
json.type track.model_name
json.extract! track, :title, :number, :duration, :created_at, :updated_at, :songsheets_count
json.has_songsheet track.has_songsheet?
json.url api_artist_album_track_url(track.artist, track.album, track, format: :json)

unless shallow
  json.album do
    json.partial! track.album, shallow: true
  end
  json.artist do
    json.partial! track.artist, shallow: true
  end
end
