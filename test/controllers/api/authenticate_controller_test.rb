require "test_helper"

class Api::AuthenticateControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    user = create(:user)
    post api_authenticate_path(format: :json), params: {email: user.email, password: user.password}
    assert_response :success

    assert_not_nil response.headers["Access-Token"]
    assert_not_nil response.headers["Expire-At"]
    assert_not_nil response.headers["Refresh-Token"]
  end

  test "create with invalid email" do
    post api_authenticate_path(format: :json), params: {email: "nope@example.com", password: "nope"}
    assert_response :unauthorized
    assert_nil response.headers["Access-Token"]
    assert_nil response.headers["Expire-At"]
    assert_nil response.headers["Refresh-Token"]
  end

  test "create with invalid password" do
    user = create(:user)
    post api_authenticate_path(format: :json), params: {email: user.email, password: "nope"}
    assert_response :unauthorized
    assert_nil response.headers["Access-Token"]
    assert_nil response.headers["Expire-At"]
    assert_nil response.headers["Refresh-Token"]
  end

  test "update with valid refresh token" do
    access_token = create(:access_token)
    put api_authenticate_path(format: :json), params: {refresh_token: access_token.refresh_token},
      headers: { "User-Agent": "testing" }
    assert_response 200
    assert_not_nil response.headers["Access-Token"]
    assert_not_nil response.headers["Expire-At"]
    assert_not_nil response.headers["Refresh-Token"]
    assert response.headers["Refresh-Token"] != access_token.refresh_token

    token = AccessToken.with_refresh_token(response.headers["Refresh-Token"]).take!
    assert_not_nil token.remote_ip
    assert_not_nil token.user_agent
  end

  test "update with blocked refresh token" do
    access_token = create(:access_token, invalidated_at: Time.now)
    put api_authenticate_path(format: :json), params: {refresh_token: access_token.refresh_token}
    assert_response 401
  end

  test "destroy" do
    delete api_authenticate_path(format: :json), headers: create(:access_token).request_headers
    assert_response 200
  end

  test "destroy with expired token" do
    delete api_authenticate_path(format: :json),
      headers: create(:access_token, expire_at: 1.second.ago).request_headers
    assert_response 401
  end

  test "destroy with invalid token" do
    delete api_authenticate_path(format: :json),
      headers: create(:access_token, invalidated_at: Time.now).request_headers
    assert_response 401
  end
end
