require "test_helper"

class Api::TracksControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_tracks_index_url
    assert_response :success
  end

  test "should get title:string" do
    get api_tracks_title:string_url
    assert_response :success
  end

  test "should get metadata:json" do
    get api_tracks_metadata:json_url
    assert_response :success
  end

  test "should get references:album" do
    get api_tracks_references:album_url
    assert_response :success
  end

  test "should get references:artist" do
    get api_tracks_references:artist_url
    assert_response :success
  end
end
