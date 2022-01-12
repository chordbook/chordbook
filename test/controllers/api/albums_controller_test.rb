require "test_helper"

class Api::AlbumsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @album = create :album
  end

  test "index" do
    get api_artist_albums_url(@album.artist, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "show" do
    get api_album_url(@album, format: :json)
    assert_response :success
  end
end
