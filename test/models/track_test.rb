require "test_helper"

class TrackTest < ActiveSupport::TestCase
  test "exposes media" do
    track = build :track, metadata: {"strMusicVid" => "http://www.youtube.com/watch?v=T0l_6Zw1828"}
    assert_equal "http://www.youtube.com/watch?v=T0l_6Zw1828", track.media
  end
end
