require "test_helper"

class Api::SetlistItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
    @setlist = create :setlist, user: @user
  end

  test "create unauthenticated" do
    post api_setlist_items_url(@setlist)
    assert_response :unauthorized
  end

  test "create someone else's setlist" do
    new_user = create(:user)
    songsheet = create :songsheet
    assert_no_difference -> { @setlist.items.count } do
      assert_raises ActiveRecord::RecordNotFound do
        post api_setlist_items_url(@setlist), params: {id: songsheet.to_param},
          headers: token_headers(new_user)
      end
    end
  end

  test "create" do
    songsheet = create :songsheet
    post api_setlist_items_url(@setlist), params: {id: songsheet.to_param},
      headers: token_headers(@user)
    assert_response :success
    assert_includes @setlist.reload.songsheets, songsheet
  end

  test "destroy" do
    songsheet = create :songsheet
    @setlist.songsheets << songsheet

    delete api_setlist_item_url(@setlist, songsheet),
      headers: token_headers(@user)

    assert_response :success
    refute_includes @setlist.reload.songsheets, songsheet
  end

  test "update" do
    songsheets = 3.times.map { create :songsheet }
    @setlist.songsheets = songsheets

    put api_setlist_item_url(@setlist, songsheets[2]), params: {item: {position: 1}},
      headers: token_headers(@user)

    assert_equal [songsheets[2], songsheets[0], songsheets[1]], @setlist.reload.songsheets.to_a
  end
end
