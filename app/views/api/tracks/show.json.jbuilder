json.partial! @track
json.extract! @track, :metadata
json.songsheets do
  json.array! @track.songsheets, partial: "api/songsheets/songsheet", as: :songsheet, shallow: true
end
