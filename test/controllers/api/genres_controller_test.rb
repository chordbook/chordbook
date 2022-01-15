require "test_helper"

class Api::GenresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @genre = create :genre
  end

  test "index" do
    get api_genres_url(format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
    assert_equal @genre.name, body[0]["name"]
  end

  test "show" do
    get api_genre_url(@genre, format: :json)
    assert_response :success
  end
end
