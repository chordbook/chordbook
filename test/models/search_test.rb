require "test_helper"

class PgSearchTest < ActiveSupport::TestCase
  setup do
    @artist = create(:artist, name: "Ed Sheeran")
    @album = create(:album, title: "=", artist: @artist)
    @track = create(:track, title: "Shivers", album: @album)
    @songsheet = create(:songsheet, title: "Bad Habits", metadata: {artist: @artist.name},
      track: create(:track, title: "Bad Habits", album: @album, artist: @artist))
  end

  test "stores result data" do
    [@songsheet, @track, @album, @artist].each do |record|
      assert_equal ["thumbnail", "title", "subtitle"].sort, record.pg_search_document.data.keys.sort
    end
  end

  test "search track and artist" do
    results = PgSearch.multisearch("Bad Habits Ed Sheeran")
    assert_includes results.map(&:searchable), @songsheet
  end

  test "search artist includes songsheets, albums, and tracks" do
    results = PgSearch.multisearch("Ed Sheeran")

    [@artist, @songsheet, @album, @track].each do |record|
      assert_includes results.map(&:searchable), record
    end
  end

  test "excludes tracks with songsheets" do
    results = PgSearch.multisearch("Bad Habits")

    assert_includes results.map(&:searchable), @songsheet
    refute_includes results.map(&:searchable), @songsheet.track
  end
end
