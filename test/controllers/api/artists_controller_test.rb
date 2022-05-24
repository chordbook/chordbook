require "test_helper"

class Api::ArtistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = create :artist
  end

  test "index unauthorized" do
    get api_artists_url(format: :json)
    assert_response :unauthorized
  end

  test "index" do
    @user = create(:user)
    @user.save_to_library(@artist)

    # Not in library
    create(:artist)

    get api_artists_url(format: :json), headers: token_headers(@user)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "show" do
    get api_artist_url(@artist, format: :json)
    assert_response :success
  end
end
