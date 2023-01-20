require "test_helper"

class Api::FlipperControllerTest < ActionDispatch::IntegrationTest
  test "show as anonymous user with no features" do
    get api_flipper_path
    assert_response :success
    assert_equal({}, response.parsed_body)
  end

  test "show as anonymous user with features" do
    Flipper.enable :a
    Flipper.disable :b
    Flipper.enable :c, create(:user) # other user

    get api_flipper_path
    assert_response :success
    assert_equal({"a" => true, "b" => false, "c" => false}, response.parsed_body)
  end

  test "show as authenticated user with feature enabled" do
    user = create(:user)
    Flipper.enable(:test, user)
    get api_flipper_path, headers: token_headers(user)
    assert_response :success
    assert_equal({"test" => true}, response.parsed_body)
  end
end
