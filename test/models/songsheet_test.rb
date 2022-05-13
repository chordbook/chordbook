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

  test "ignores case when matching track title" do
    track = create :track
    songsheet = create :songsheet, title: track.title.upcase, metadata: {artist: track.artist.name}
    assert_equal track, songsheet.track
  end

  test "associates with multiple artists" do
    artists = [create(:artist), create(:artist)]
    songsheet = create :songsheet, metadata: {artist: artists.map(&:name).join(", ")}

    assert_equal artists, songsheet.artists
  end

  test "finds verified artist with similar name" do
    artist = create :artist, name: "The Everly Brothers", verified: true
    songsheet = create :songsheet, metadata: {artist: "Everly Brothers"}

    assert_equal [artist], songsheet.artists
  end

  test "does not association track by different artist" do
    artist = create :artist, name: "Trampled By Turtles"
    track = create :track, title: "Wildflowers", artist: artist

    songsheet = create :songsheet, title: track.title, metadata: {artist: "Tom Petty"}
    assert_nil songsheet.track
  end

  test "all_media returns tracks and songsheet" do
    songsheet = create :songsheet, :with_track

    media = [
      create(:medium, record: songsheet),
      create(:medium, record: songsheet.track)
    ]

    assert_equal media.to_set, songsheet.all_media.to_set
  end
end
