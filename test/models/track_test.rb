require "test_helper"

class TrackTest < ActiveSupport::TestCase
  test "associates with songsheet on save" do
    artist = create :artist, name: "Tom Petty"
    songsheet = create :songsheet, metadata: {title: "Wildflowers", artist: artist.name}
    track = create :track, title: songsheet.title, artist: artist

    assert_equal track, songsheet.reload.track
  end

  test "does not associate with songsheets by other artists on save" do
    artist = create :artist, name: "Tom Petty"
    songsheet = create :songsheet, metadata: {title: "Wildflowers", artist: artist.name}

    create :track, title: songsheet.title, artist: create(:artist, name: "Trampled By Turtles")

    assert_nil songsheet.reload.track
  end
end
