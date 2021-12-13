require "test_helper"

class Api::TracksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = Artist.create! name: "The Beatles"
    @album = Album.create! title: "Abbey Road", artist: @artist
    @track = Track.create! title: "Come Together", artist: @artist, album: @album
  end

  test "index with album" do
    get api_artist_album_tracks_url(@artist, @album, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

  test "index with artist" do
    get api_artist_tracks_url(@artist, format: :json)
    assert_response :success
    body = JSON.parse(response.body)
    assert_equal 1, body.length
  end

end
