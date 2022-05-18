require "test_helper"

class SongsheetTest < ActiveSupport::TestCase
  test "all_media returns tracks and songsheet" do
    songsheet = create :songsheet, :with_track

    media = [
      create(:medium, record: songsheet),
      create(:medium, record: songsheet.track)
    ]

    assert_equal media.to_set, songsheet.all_media.to_set
  end
end
