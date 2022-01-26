require "test_helper"

class GenreTest < ActiveSupport::TestCase
  test "example_artist" do
    genre = create :genre
    artist = create :artist, thumbnail: "a thumnail"
    track = create :track, artist: artist, genre: genre, listeners: 999

    # less popular track
    create :track, artist: artist, genre: genre, listeners: 1

    assert_equal track, genre.example_track
    assert_equal artist, genre.example_artist
    assert_equal "a thumnail", genre.thumbnail
  end
end
