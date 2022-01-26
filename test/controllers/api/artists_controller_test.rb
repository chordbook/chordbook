require "test_helper"

class Api::ArtistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = create :artist
  end

  test "index" do
    get api_artists_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "show" do
    get api_artist_url(@artist, format: :json)
    assert_response :success
  end
end
