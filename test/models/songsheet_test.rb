require "test_helper"

class SongsheetTest < ActiveSupport::TestCase
  test "associates with artist and track on save" do
    track = create :track
    songsheet = create :songsheet, title: track.title, metadata: {artist: track.artist.name}

    assert_equal [track.artist], songsheet.artists
    assert_equal track, songsheet.track

    track.reload
    assert track.has_songsheet?
  end

  test "does not association track by different artist" do
    artist = create :artist, name: "Trampled By Turtles"
    track = create :track, title: "Wildflowers", artist: artist

    songsheet = create :songsheet, title: track.title, metadata: {artist: "Tom Petty"}
    assert_nil songsheet.track
  end
end
