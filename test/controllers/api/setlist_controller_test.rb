require "test_helper"

class Api::SetlistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
  end

  test "index requires authentication" do
    get api_setlists_url(format: :json)
    assert_response :unauthorized
  end

  test "index unauthorized" do
    get api_setlists_url(format: :json)
    assert_response :unauthorized
  end

  test "index" do
    # Not in library
    create(:setlist)

    get api_setlists_url(format: :json), headers: token_headers(@user)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @user.setlists.count, body.length
    assert_not_equal Setlist.count, body.length
  end

  test "create" do
    assert_difference -> { @user.owned_setlists.count } do
      post api_setlists_url(format: :json), params: {setlist: {title: "testing"}},
        headers: token_headers(@user)
      assert_response :success
    end
  end

  test "show any setlist" do
    @setlist = create :setlist
    get api_setlist_url(@setlist, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @setlist.title, body["title"]
  end

  test "destroy owned setlists" do
    setlist = create :setlist, user: @user

    assert_difference -> { @user.owned_setlists.count }, -1 do
      delete api_setlist_url(setlist, format: :json),
        headers: token_headers(@user)
    end
    assert_response :success
  end

  test "destroy fails with setlist owned by someone else" do
    setlist = create(:setlist) # owned by someone else

    assert_raises ActiveRecord::RecordNotFound do
      delete api_setlist_url(setlist, format: :json),
        headers: token_headers(@user)
    end
  end
end
