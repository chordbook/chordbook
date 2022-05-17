require "test_helper"

class ContentControllerTest < ActionDispatch::IntegrationTest
  test "ping" do
    get "/ping"
    assert_response :success
  end
end
