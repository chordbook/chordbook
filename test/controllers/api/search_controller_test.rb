require "test_helper"

class Api::SearchControllerTest < ActionDispatch::IntegrationTest
  setup do
    with_search do
      @artist = create :artist, name: "Jeff Buckly"
      @album = create :album, artist: @artist, title: "Hallelujah"
    end
  end

  test "index" do
    get api_search_url(q: @artist.name, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 2, body.length
    assert_equal @artist.name, body[0]["title"]
    assert_equal @album.title, body[1]["title"]
  end

  test "index with type" do
    with_search do
      track = create :track
      create :songsheet, title: track.title

      # Create artist with same name, which should be excluded from results
      create :artist, name: track.title

      get api_search_url(q: track.title, type: "track,songsheet", format: :json)
      assert_response :success
      assert_equal 2, JSON.parse(response.body).length
    end
  end

  test "convert" do
    search = Searchjoy::Search.create!(search_type: "Artist", query: @artist.name)
    assert_difference -> { search.conversions.count } do
      get api_convert_search_url(search_id: search.id, id: @artist.uid)
      assert_response 201
    end
  end
end
