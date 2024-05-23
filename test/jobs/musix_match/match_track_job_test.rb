require "test_helper"

class MusixMatch::MatchTrackJobTest < ActiveJob::TestCase
  setup do
    Flipper.enable :musixmatch
  end

  test "saves reference to matched track" do
    artist = create :artist, name: "The Beatles"
    album = create :album, title: "Let It Be", artist: artist
    track = create :track, title: "Let It Be", album: album, artist: artist

    assert_difference -> { track.references.count } do
      # should not duplicate on second run
      2.times do
        VCR.use_cassette("musixmatch/matcher.track.get") do
          MusixMatch::MatchTrackJob.new.perform(track)
        end
      end
    end

    reference = track.references.last
    assert_equal "musixmatch", reference.source
    assert_equal "277941381", reference.identifier
    assert_equal 57, reference.data["track_rating"]
  end
end
