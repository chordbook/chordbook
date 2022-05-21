require "test_helper"

class Api::AuthenticateControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    user = create(:user, password: "testing")
    post api_authenticate_path(format: :json), params: {email: user.email, password: "testing"}
    assert_response :success

    assert_not_nil response.headers["Access-Token"]
    assert_not_nil response.headers["Expire-At"]
  end

  test "create with invalid email" do
    post api_authenticate_path(format: :json), params: {email: "nope@example.com", password: "nope"}
    assert_response :unauthorized
    assert_nil response.headers["Access-Token"]
    assert_nil response.headers["Expire-At"]
  end

  test "create with invalid password" do
    user = create(:user)
    post api_authenticate_path(format: :json), params: {email: user.email, password: "nope"}
    assert_response :unauthorized
    assert_nil response.headers["Access-Token"]
    assert_nil response.headers["Expire-At"]
  end
end
