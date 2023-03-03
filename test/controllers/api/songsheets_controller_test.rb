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
    assert_equal @songsheet.to_param, body[0]["id"]
  end

  test "show" do
    get api_songsheet_url(@songsheet, format: :json)
    assert_response :success
  end

  test "create unauthenticated" do
    post api_songsheets_url
    assert_response :unauthorized
  end

  test "create" do
    assert_difference -> { Songsheet.count }, 1 do
      post api_songsheets_url(format: :json), headers: token_headers(create(:user)), params: {
        songsheet: {
          source: "test",
          metadata: {title: "Hello World", subtitle: "Nice to meet you"}
        }
      }
      assert_response :created
    end
  end

  test "update unauthorized" do
    songsheet = create :songsheet
    patch api_songsheet_url(songsheet, format: :json), params: {
      songsheet: {metadata: {title: "Hello World"}}
    }
    assert_response :unauthorized
  end

  test "update" do
    PaperTrail.enabled = true
    user = create(:user)
    songsheet = create :songsheet

    assert_difference -> { songsheet.versions.count }, 1 do
      patch api_songsheet_url(songsheet, format: :json), headers: token_headers(user), params: {
        songsheet: {metadata: {title: "Hello World"}}
      }
    end

    songsheet.reload

    assert_response :success
    assert_equal "Hello World", songsheet.title
    assert_equal user.id, songsheet.versions.last.whodunnit
  end
end
