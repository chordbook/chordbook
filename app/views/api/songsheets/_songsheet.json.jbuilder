shallow ||= false

json.extract! songsheet, :id, :title, :metadata, :created_at, :updated_at

if !shallow && songsheet.track
  json.track do
    json.partial! "api/tracks/track", track: songsheet.track
  end
end

if !shallow && songsheet.artists.any?
  json.artists do
    json.array! songsheet.artists, partial: "api/artists/artist", as: :artist
  end
end

json.url api_songsheet_url(songsheet, format: :json)
