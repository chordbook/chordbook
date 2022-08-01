require "test_helper"

class LookupMetadataTest < ActiveJob::TestCase
  setup do
    LookupMetadata.throttle = Throttle.new(0)
  end

  test "new artist" do
    VCR.use_cassette("tadb/the_beatles") do
      assert_difference -> { Album.count } => 50, -> { Artist.count } => 1 do
        LookupMetadata.perform_now "The Beatles"
      end

      artist = Artist.first
      assert_instance_of Hash, artist.metadata
      assert_equal "111247", artist.metadata["idArtist"]
    end
  end

  test "existing artist, non-recursive" do
    artist = create :artist, name: "The Beatles", metadata: {idArtist: 111247, intFormedYear: 1900}

    VCR.use_cassette("tadb/the_beatles") do
      # Should not recursively sync albums
      assert_difference -> { Artist.count } => 0, -> { artist.albums.count } => 0 do
        LookupMetadata.perform_now artist.name, recursive: false
      end
    end

    artist.reload
    assert_instance_of Hash, artist.metadata
    assert_equal "111247", artist.metadata["idArtist"]
    assert_equal "1957", artist.metadata["intFormedYear"]
  end

  test "normalizes artist name" do
    VCR.use_cassette("tadb/simon_and_garfunkel") do
      LookupMetadata.perform_now "Simon and Garfunkel", recursive: false
    end

    assert_equal "Simon & Garfunkel", Artist.first.name
  end

  test "sanity check for duplicates" do
    artist = create :artist, name: "Simon and Garfunkel", metadata: {idArtist: "112256"}

    VCR.use_cassette("tadb/simon_and_garfunkel") do
      assert_no_difference -> { Artist.count } do
        LookupMetadata.new.perform artist.name, recursive: false
      end
    end
  end

  test "album" do
    VCR.use_cassette("tadb/the_beatles") do
      artist = create :artist, name: "The Beatles", metadata: {idArtist: 111247}
      album = create :album, title: "The White Album", artist: artist

      assert_difference -> { album.tracks.count }, 30 do
        LookupMetadata.new.sync_album album
      end

      assert_instance_of Hash, album.metadata
      assert_equal "2213204", album.metadata["idAlbum"]
    end
  end
end
