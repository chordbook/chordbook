require "test_helper"

class TrackTest < ActiveSupport::TestCase
  test "adds metadata strMusicVid to media" do
    track = create :track, media: ["https://www.youtube.com/watch?v=6XIBdSLRz3o"]
    create :reference, record: track, source: :theaudiodb, data: {"strMusicVid" => "http://www.youtube.com/watch?v=T0l_6Zw1828"}

    expected = [
      "https://www.youtube.com/watch?v=6XIBdSLRz3o",
      "http://www.youtube.com/watch?v=T0l_6Zw1828"
    ]
    assert_equal expected, track.reload.media
  end

  test "lookup returns track with more listeners" do
    track = create :track, listeners: 10
    create :track, title: track.title, artist: track.artist, listeners: 2
    create :track, title: track.title, artist: track.artist, listeners: nil # unknown

    assert_equal track, Track.lookup(track.title)
  end

  test "gets genre from metadata" do
    track = create :track
    create :reference, record: track, source: :theaudiodb, data: {strGenre: "R&B"}
    assert_equal "R&B", track.reload.genre.name
  end

  test "falls back to album genre" do
    album = create(:album, genre: create(:genre))
    track = create(:track, album: album)

    assert_equal album.genre, track.genre
  end

  test "musixmatch lookup" do
    assert_no_enqueued_jobs { create :track, songsheets_count: 0 }
    assert_enqueued_with(job: MusixMatch::MatchTrackJob) { create :track, songsheets_count: 1 }
  end
end
