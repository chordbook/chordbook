json.partial! @songsheet
json.extract! @songsheet, :source, :imported_from
json.media @songsheet.all_media
json.artists do
  json.array! @songsheet.artists, partial: "api/artists/artist", as: :artist
end

json.extract! @songsheet, :copyright if Flipper.enabled?(:musixmatch)
