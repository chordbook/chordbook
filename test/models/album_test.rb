require "test_helper"

class AlbumTest < ActiveSupport::TestCase
  test "gets genre from metadata" do
    assert_equal "R&B", create(:album, metadata: {strGenre: "R&B"}).genre.name
  end

  test "falls back to artist genre" do
    artist = create(:artist, genre: create(:genre))
    album = create(:album, artist: artist)

    assert_equal artist.genre, album.genre
  end
end
