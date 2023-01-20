require "test_helper"

class Api::FlipperControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
  end

  test "show as anonymous user with feature disabled" do
    get api_flipper_path("test")
    assert_response :success
    assert_equal false, response.parsed_body["enabled"]
  end

  test "show as anonymous user with feature enabled" do
    Flipper.enable(:test)
    get api_flipper_path("test")
    assert_response :success
    assert_equal true, response.parsed_body["enabled"]
  end
end
