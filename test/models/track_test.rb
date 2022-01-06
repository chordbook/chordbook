require "test_helper"

class TrackTest < ActiveSupport::TestCase
  test "associates with songsheet on save" do
    artist = Artist.create!(name: "Tom Petty")
    songsheet = Songsheet.create!(metadata: {title: "Wildflowers", artist: artist.name})

    track = Track.create!(title: songsheet.title, artist: artist)

    assert_equal track, songsheet.reload.track
  end

  test "does not associate with songsheets by other artists on save" do
    artist = Artist.create!(name: "Tom Petty")
    songsheet = Songsheet.create!(metadata: {title: "Wildflowers", artist: artist.name})

    track = Track.create!(title: songsheet.title, artist: Artist.create!(name: "Trampled By Turtles"))

    assert_nil songsheet.reload.track
  end
end
