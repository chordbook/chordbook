require "test_helper"

class Api::HomeControllerTest < ActionDispatch::IntegrationTest
  test "show unauthenticated" do
    get api_home_path(format: :json)
    assert_response :success
  end

  test "show authenticated" do
    user = create(:user)
    get api_home_path(format: :json), headers: token_headers(user)
    assert_response :success
  end
end
