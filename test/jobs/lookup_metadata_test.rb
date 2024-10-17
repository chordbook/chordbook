require "test_helper"

class LookupMetadataTest < ActiveJob::TestCase
  setup do
    LookupMetadata.throttle = Throttle.new(0)
  end

  test "new artist" do
    VCR.use_cassette("tadb/the_beatles") do
      assert_difference -> { Album.count } => 51, -> { Artist.count } => 1 do
        LookupMetadata.new.perform "The Beatles"
      end

      artist = Artist.first
      reference = artist.theaudiodb_reference
      assert_equal "The Beatles", artist.name
      assert_equal "111247", reference.data["idArtist"]
    end
  end

  test "existing artist, non-recursive" do
    artist = create :artist, name: "The Beatles"
    reference = artist.references.create! source: :theaudiodb, identifier: 111247, data: {intFormedYear: 1900}

    VCR.use_cassette("tadb/the_beatles") do
      # Should not recursively sync albums
      assert_difference -> { Artist.count } => 0, -> { artist.albums.count } => 0 do
        LookupMetadata.new.perform artist.name, recursive: false
      end
    end

    reference.reload
    assert_equal "111247", reference.data["idArtist"]
    assert_equal "1957", reference.data["intFormedYear"]
  end

  test "normalizes artist name" do
    VCR.use_cassette("tadb/simon_and_garfunkel") do
      LookupMetadata.new.perform "Simon and Garfunkel", recursive: false
    end

    assert_equal "Simon & Garfunkel", Artist.first.name
  end

  test "sanity check for duplicates" do
    artist = create :artist, name: "Simon and Garfunkel"
    create :reference, record: artist, source: :theaudiodb, identifier: "112256"

    VCR.use_cassette("tadb/simon_and_garfunkel") do
      assert_no_difference -> { Artist.count } do
        LookupMetadata.new.perform artist.name, recursive: false
      end
    end
  end

  test "album" do
    VCR.use_cassette("tadb/the_beatles") do
      artist = create :artist, name: "The Beatles"
      album = create :album, title: "The White Album", artist: artist
      create :reference, record: album, source: :theaudiodb, identifier: "2213204"

      assert_difference -> { album.tracks.count }, 30 do
        LookupMetadata.new.sync_tracks album
      end
    end
  end
end
