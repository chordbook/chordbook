require "test_helper"

class Api::DiscoverControllerTest < ActionDispatch::IntegrationTest
  test "includes top setlists for app user" do
    setlist = create :setlist, user: User.app

    get api_discover_path(format: :json)
    assert_response :success

    assert_equal 4, response.parsed_body["setlists"].size
  end
end
