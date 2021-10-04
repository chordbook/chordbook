require "test_helper"

class SongsheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @songsheet = songsheets(:one)
  end

  test "should get index" do
    get songsheets_url
    assert_response :success
  end

  test "should get new" do
    get new_songsheet_url
    assert_response :success
  end

  test "should create songsheet" do
    assert_difference('Songsheet.count') do
      post songsheets_url, params: { songsheet: { body: @songsheet.body } }
    end

    assert_redirected_to songsheet_url(Songsheet.last)
  end

  test "should show songsheet" do
    get songsheet_url(@songsheet)
    assert_response :success
  end

  test "should get edit" do
    get edit_songsheet_url(@songsheet)
    assert_response :success
  end

  test "should update songsheet" do
    patch songsheet_url(@songsheet), params: { songsheet: { body: @songsheet.body } }
    assert_redirected_to songsheet_url(@songsheet)
  end

  test "should destroy songsheet" do
    assert_difference('Songsheet.count', -1) do
      delete songsheet_url(@songsheet)
    end

    assert_redirected_to songsheets_url
  end
end
