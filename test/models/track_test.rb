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

  test "associates media on save" do
    track = create :track, metadata: {"strMusicVid" => "http://www.youtube.com/watch?v=T0l_6Zw1828"}

    assert_equal 1, track.media.count
    assert_equal "http://www.youtube.com/watch?v=T0l_6Zw1828", track.media.first.uri
  end
end
