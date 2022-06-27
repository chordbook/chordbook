json.partial! "api/songsheets/songsheet", songsheet: @songsheet
json.extract! @songsheet, :source, :imported_from
json.media @songsheet.all_media
