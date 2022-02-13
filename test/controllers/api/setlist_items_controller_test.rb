require "test_helper"

class Api::SetlistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setlist = create :setlist
  end

  test "create" do
    songsheet = create :songsheet
    post api_setlist_items_url(@setlist), params: {item: {songsheet_id: songsheet.id}}
    assert_response :success
    assert_includes @setlist.reload.songsheets, songsheet
  end

  test "destroy" do
    songsheet = create :songsheet
    @setlist.songsheets << songsheet

    delete api_setlist_item_url(@setlist, songsheet)
    assert_response :success
    refute_includes @setlist.reload.songsheets, songsheet
  end

  test "update" do
    songsheets = 3.times.map { create :songsheet }
    @setlist.songsheets = songsheets

    put api_setlist_item_url(@setlist, songsheets[2]), params: {item: {position: 1}}
    assert_equal [songsheets[2], songsheets[0], songsheets[1]], @setlist.reload.songsheets.to_a
  end
end
