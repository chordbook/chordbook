json.partial! "api/songs/song", song: @song
json.extract! @song, :source
