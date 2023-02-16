require "test_helper"

class Api::LibraryControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create :user
  end

  test "create unauthenticated" do
    post api_library_path
    assert_response :unauthorized
  end

  test "create with valid params" do
    songsheet = create(:songsheet)

    assert_difference -> { @user.songsheets.count } do
      post api_library_path, params: {id: songsheet.to_param},
        headers: token_headers(@user)
    end

    assert @user.songsheets.find(songsheet.id)

    assert_response 201
  end

  test "create duplicate" do
    songsheet = create(:songsheet)
    @user.library.add(songsheet)

    assert_no_difference -> { @user.songsheets.count } do
      post api_library_path, params: {id: songsheet.to_param},
        headers: token_headers(@user)
    end

    assert_response :success
  end

  test "create with invalid type" do
    assert_no_difference -> { @user.library.count } do
      post api_library_path, params: {id: @user.to_param},
        headers: token_headers(@user)
    end

    assert_response 422
  end

  test "create with non-existent record" do
    assert_no_difference -> { @user.songsheets.count } do
      post api_library_path, params: {id: Songsheet.new(id: SecureRandom.uuid).to_param},
        headers: token_headers(@user)
    end

    assert_response 422
  end

  test "show" do
    songsheet = create(:songsheet)
    @user.songsheets << songsheet

    get api_library_path, params: {id: songsheet.to_param},
      headers: token_headers(@user)
    assert_response :success

    assert_raises ActiveRecord::RecordNotFound do
      get api_library_path, params: {id: create(:songsheet).to_param},
        headers: token_headers(@user)
    end
  end

  test "destroy" do
    songsheet = create(:songsheet)
    @user.songsheets << songsheet

    delete api_library_path, params: {id: songsheet.to_param},
      headers: token_headers(@user)
    assert_response :success
  end
end
