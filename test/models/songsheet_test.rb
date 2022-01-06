require "test_helper"

class ArtistTest < ActiveSupport::TestCase
  test "associates with artist and track on save" do
    artist = Artist.create!(name: "Tom Petty")
    track = Track.create!(title: "Wildflowers", artist: artist)

    songsheet = Songsheet.create!(metadata: {title: track.title, artist: artist.name})
    assert_equal [artist], songsheet.artists
    assert_equal track, songsheet.track

    track.reload
    assert track.has_songsheet?
  end

  test "does not association track by different artist" do
    artist = Artist.create!(name: "Trampled By Turtles")
    track = Track.create!(title: "Wildflowers", artist: artist)

    songsheet = Songsheet.create!(metadata: {title: track.title, artist: "Tom Petty"})
    assert_nil songsheet.track
  end
end
