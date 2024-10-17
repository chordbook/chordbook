require "test_helper"

class MusixMatchTest < ActiveSupport::TestCase
  test "match_track" do
    VCR.use_cassette("musixmatch/matcher.track.get") do
      result = MusixMatch.match_track(q_artist: "The Beatles", q_track: "Let It Be", q_album: "Let It Be")
      assert_equal 277941381, result["message"]["body"]["track"]["track_id"]
    end
  end

  test "nope" do
    VCR.use_cassette("musixmatch/matcher.track.get") do
      MusixMatch.match_track(
        q_artist: "Elivs Presley",
        q_track: "All Shook Up",
        q_album: "From Memphis to Vegas / From Vegas to Memphis"
      )
    end
  end
end
