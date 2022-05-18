require "test_helper"

class TrackTest < ActiveSupport::TestCase
  test "associates media on save" do
    track = create :track, metadata: {"strMusicVid" => "http://www.youtube.com/watch?v=T0l_6Zw1828"}

    assert_equal 1, track.media.count
    assert_equal "http://www.youtube.com/watch?v=T0l_6Zw1828", track.media.first.uri
  end
end
