require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "unauthenticated" do
    post "/setlists.json", params: {setlist: attributes_for(:setlist)}
    assert_response 401
  end

  test "with valid token" do
    post "/setlists.json", params: {setlist: attributes_for(:setlist)},
      headers: create(:access_token).request_headers

    assert_response :success
  end

  test "with expired token" do
    post "/setlists.json", params: {setlist: attributes_for(:setlist)},
      headers: create(:access_token, expire_at: 1.second.ago).request_headers
    assert_response 401
  end
end
