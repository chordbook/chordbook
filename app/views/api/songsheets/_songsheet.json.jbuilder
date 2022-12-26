shallow ||= false

json.id songsheet.to_param
json.type songsheet.model_name
json.extract! songsheet, :title, :metadata, :created_at, :updated_at
json.subtitle Array(songsheet.metadata["artist"] || songsheet.metadata["subtitle"]).to_sentence
json.url api_songsheet_url(songsheet, format: :json)

unless shallow
  json.track do
    json.partial! songsheet.track if songsheet.track
  end

  json.artists do
    json.array! songsheet.artists, partial: "api/artists/artist", as: :artist
  end
end
