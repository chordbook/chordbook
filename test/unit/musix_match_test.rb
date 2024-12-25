require "test_helper"

class MusixMatchTest < ActiveSupport::TestCase
  test "match_track" do
    VCR.use_cassette("musixmatch/matcher.track.get") do
      result = MusixMatch.match_track(q_artist: "The Beatles", q_track: "Let It Be", q_album: "Let It Be")
      assert_equal 277941381, result["message"]["body"]["track"]["track_id"]
    end
  end
end
