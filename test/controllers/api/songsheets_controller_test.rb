require "test_helper"

class Api::SongsheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = create :artist, name: "John Mayer"
    @songsheet = create :songsheet, title: "Why Georgia", artists: [@artist],
      metadata: {media: "vid1"}
  end

  test "GET /songsheets unauthorized" do
    get api_songsheets_url(format: :json)
    assert_response :unauthorized
  end

  test "GET /songsheets returns library songsheets" do
    @user = create :user
    @user.library.add @songsheet

    # not in library
    create(:songsheet)

    get api_songsheets_url(format: :json), headers: token_headers(@user)
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
    track = create :track, title: @songsheet.title, artist: @artist
    @songsheet.update(track: track)

    # create another songsheet, which should not show up in results
    create :songsheet, title: "Testing", metadata: {subtitle: "Testing"}

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
