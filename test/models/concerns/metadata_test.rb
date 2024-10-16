require "test_helper"

class MetadataTest < ActiveSupport::TestCase
  test "moves metadata with matching attribute name to stored attribute" do
    songsheet = Songsheet.create!(metadata: {title: "Title", subtitle: "Subtitle"})
    assert_equal "Title", songsheet.title
    assert_nil songsheet.metadata["title"]
  end

  test "does not overwrite attribute with nil value" do
    songsheet = Songsheet.create!(title: "Title", metadata: {subtitle: "Subtitle"})
    assert_equal "Title", songsheet.title
    assert_nil songsheet.metadata["title"]
  end

  test "moves metdata from mapping to stored attribute" do
    album = Album.create!(title: "The White Album",
      artist: Artist.create!(name: "The Beatles"),
      metadata: {"intYearReleased" => "1968"})

    assert_equal 1968, album.released
    assert_nil album.metadata["intYearReleased"]
  end

  test "maps metadata to accessors" do
  end
end
