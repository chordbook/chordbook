require "test_helper"

class Api::SongsheetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @songsheet = Songsheet.create! title: "Why Georgia", subtitle: "John Mayer"
  end

  test "index" do
    get api_songsheets_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "show" do
    get api_songsheet_url(@songsheet, format: :json)
    assert_response :success
  end
end
