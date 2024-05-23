require "test_helper"

class SearchTest < ActiveSupport::TestCase
  setup do
    with_search do
      @artist = create(:artist, name: "Ed Sheeran")
      @album = create(:album, title: "=", artist: @artist)
      @track = create(:track, title: "Shivers", album: @album)
      @songsheet = create(:songsheet, title: "Bad Habits", metadata: {artist: @artist.name},
        track: create(:track, title: "Bad Habits", album: @album, artist: @artist))
      @setlist = create(:setlist, title: "Best of Ed Sheeran", user: User.app, songsheets: [@songsheet])
    end
  end

  def search(query, **)
    Search.new(query: query, **).results
  end

  test "search track and artist" do
    assert_includes search("Bad Habits Ed Sheeran"), @songsheet
  end

  test "search includes songsheets, albums, and setlists" do
    results = search("Ed Sheeran")

    [@artist, @songsheet, @album, @setlist].each do |record|
      assert_includes results, record
    end
  end
end
