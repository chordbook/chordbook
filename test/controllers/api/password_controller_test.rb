require "test_helper"

class Api::PasswordControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "create" do
    perform_enqueued_jobs do
      post api_password_path(format: :json), params: {email: @user.email}
    end
    assert_response 200
    assert_emails 1
    assert @user.reload.password_reset_token

    # Does not return authentication headers
    assert_nil response.headers["Access-Token"]
    assert_nil response.headers["Expire-At"]
    assert_nil response.headers["Refresh-Token"]
  end

  test "show" do
    @user.generate_password_reset!

    get api_password_path(format: :json), params: {
      token: @user.password_reset_token
    }
    assert_response 200
  end

  test "update" do
    @user.generate_password_reset!
    new_password = SecureRandom.alphanumeric

    put api_password_path(format: :json), params: {
      token: @user.password_reset_token,
      password: new_password
    }
    assert_response 200

    assert_equal @user, User.authenticate!(@user.email, new_password)
  end

  test "update with old token" do
    @user.generate_password_reset!
    @user.update! password_reset_sent_at: 3.hours.ago

    put api_password_path(format: :json), params: {
      token: @user.password_reset_token,
      password: SecureRandom.alphanumeric
    }
    assert_response 401
  end

  test "update with invalid token" do
    put api_password_path(format: :json), params: {token: "Nope!"}
    assert_response :unauthorized
  end

  test "update with invalid password" do
    @user.generate_password_reset!
    new_password = "toosimple"

    put api_password_path(format: :json), params: {
      token: @user.password_reset_token,
      password: new_password
    }
    assert_response 422
  end
end
