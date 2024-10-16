require "test_helper"

class MergeableTest < ActiveSupport::TestCase
  test "copies attributes and associations" do
    songsheet1 = create(:songsheet, setlists: [create(:setlist)])
    songsheet2 = create(:songsheet, setlists: [create(:setlist)])

    user = create(:user)
    user.library.add(songsheet2)

    assert_difference -> { Songsheet.count }, -1 do
      songsheet1.merge(songsheet2)
    end
    songsheet1.reload

    assert_equal 2, songsheet1.setlists.count
    assert_equal [songsheet1], user.reload.songsheets.to_a
  end
end
