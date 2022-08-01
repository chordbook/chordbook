shallow ||= false

json.id songsheet.to_param
json.extract! songsheet, :uid, :title, :metadata, :created_at, :updated_at
json.url api_songsheet_url(songsheet, format: :json)

unless shallow
  json.track do
    json.partial! songsheet.track if songsheet.track
  end

  json.artists do
    json.array! songsheet.artists, partial: "api/artists/artist", as: :artist
  end
end
