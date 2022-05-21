require "test_helper"

class Api::UsersControllerTest < ActionDispatch::IntegrationTest
  test "create with valid params" do
    post api_users_path(format: :json), params: {user: attributes_for(:user)}
    assert_response 201

    assert_not_nil response.headers["Access-Token"]
    assert_not_nil response.headers["Expire-At"]
  end

  test "create with duplicate email" do
    user = create(:user)
    post api_users_path(format: :json), params: {user: attributes_for(:user, email: user.email)}
    assert_response 422
  end

  test "create without password" do
    post api_users_path(format: :json), params: {user: attributes_for(:user, password: nil)}
    assert_response 422
  end

  test "destroy" do
    token = create(:token)
    assert_difference -> { User.count } => -1 do
      delete api_user_path(token.user, format: :json), headers: token.request_headers
    end
  end

  test "destroy without authentication" do
    user = create(:user)
    delete api_user_path(user, format: :json)
    assert_response 401
  end
end
