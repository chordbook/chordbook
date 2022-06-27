require "test_helper"

class SongsheetTest < ActiveSupport::TestCase
  test "all_media returns tracks and songsheet" do
    songsheet = create :songsheet,
      metadata: {media: ["vid1", "vid2"]},
      track: create(:track, media: "vid3")

    assert_equal ["vid1", "vid2", "vid3"], songsheet.all_media
  end

  test "all_media without media returns empty array" do
    songsheet = create :songsheet
    assert_equal [], songsheet.all_media
  end

  test "all_media without track returns songsheet media" do
    songsheet = create :songsheet, metadata: {media: "vid1"}
    assert_equal ["vid1"], songsheet.all_media
  end
end
