require "test_helper"

class Api::SetlistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setlist = create :setlist
  end

  test "index" do
    get api_setlists_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "create" do
    assert_difference -> { Setlist.count } do
      post api_setlists_url(format: :json), params: {setlist: {title: "testing"}}
      assert_response :success
    end
  end

  test "show" do
    get api_setlist_url(@setlist, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @setlist.title, body["title"]
  end

  test "destroy" do
    assert_difference -> { Setlist.count }, -1 do
      delete api_setlist_url(@setlist, format: :json)
    end
    assert_response :success
  end
end
