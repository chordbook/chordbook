require "test_helper"

class Api::TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @track = create :track
  end

  test "index with album" do
    get api_artist_album_tracks_url(@track.artist, @track.album, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "index with artist" do
    get api_artist_tracks_url(@track.artist, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "show" do
    get api_track_url(@track, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal @track.title, body['title']
  end
end
