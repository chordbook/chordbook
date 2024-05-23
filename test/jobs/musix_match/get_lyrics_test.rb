require "test_helper"

class MusixMatch::MatchTrackJobTest < ActiveJob::TestCase
  setup do
    Flipper.enable :musixmatch
  end

  test "updates reference with lyrics" do
    reference = Reference.create! record: create(:track), source: :musixmatch, identifier: 277941381, data: {"track_rating" => 57}
    VCR.use_cassette("musixmatch/track.lyrics.get") do
      MusixMatch::GetLyrics.perform_now(reference)
      assert_equal "When I find myself in times of trouble", reference.reload.data["lyrics_body"].split("\n").first
      assert_equal 57, reference.data["track_rating"]
    end
  end
end
