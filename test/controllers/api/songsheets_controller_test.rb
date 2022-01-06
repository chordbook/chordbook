require "test_helper"

class Api::SongsheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @songsheet = Songsheet.create! title: "Why Georgia", artist: "John Mayer"
  end

  test "GET /songsheets" do
    get api_songsheets_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "GET /artists/:artist_id/songsheets" do
    get api_artist_songsheets_url(@songsheet.artists.first, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "GET /tracks/:track_id/songsheets" do
    # Create track, which will associate itself with the songsheet
    track = Track.create!(title: @songsheet.title, artist: @songsheet.artists.first)

    # create another songsheet, which should not show up in results
    Songsheet.create!(title: "Testing", subtitle: "Testing")

    get api_track_songsheets_url(track, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
    assert_equal @songsheet.id, body[0]["id"]
  end

  test "show" do
    get api_songsheet_url(@songsheet, format: :json)
    assert_response :success
  end
end
