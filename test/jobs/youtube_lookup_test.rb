require "test_helper"

class YoutubeLookupTest < ActiveJob::TestCase
  test "finds youtube videos for track" do
    track = create :track, title: "Banana Pancakes", artist: create(:artist, name: "Jack Johnson")
    VCR.use_cassette("youtube/banana_pancakes") do
      YoutubeLookup.new.perform track

      assert_equal 2, track.reload.media.size
    end
  end
end
