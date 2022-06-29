require "test_helper"

class LookupMetadataTest < ActiveJob::TestCase
  setup do
    LookupMetadata.throttle = Throttle.new(0)
  end

  test "new artist" do
    VCR.use_cassette("tadb/the_beatles") do
      artist = create :artist, name: "The Beatles"
      refute artist.reload.verified?

      assert_difference -> { artist.albums.count }, 50 do
        LookupMetadata.perform_now artist
      end

      assert_instance_of Hash, artist.metadata
      assert_equal "111247", artist.metadata["idArtist"]
      assert artist.verified?
    end
  end

  test "artist, non-recursive" do
    artist = create :artist, name: "The Beatles", metadata: {idArtist: 111247, intFormedYear: 1900}

    VCR.use_cassette("tadb/the_beatles") do
      # Should not recursively sync albums
      assert_difference -> { artist.albums.count }, 0 do
        LookupMetadata.perform_now artist, recursive: false
      end

      assert_instance_of Hash, artist.metadata
      assert_equal "111247", artist.metadata["idArtist"]
      assert_equal "1957", artist.metadata["intFormedYear"]
    end
  end

  test "normalizes artist name" do
    VCR.use_cassette("tadb/simon_and_garfunkel") do
      artist = create :artist, name: "Simon and Garfunkel"
      LookupMetadata.perform_now artist, recursive: false
      assert_equal "Simon & Garfunkel", artist.name
    end
  end

  test "sanity check for duplicates" do
    VCR.use_cassette("tadb/simon_and_garfunkel") do
      artist = create :artist, name: "Simon and Garfunkel", metadata: { idArtist: "112256" }
      duplicate = create :artist, name: artist.name

      assert_difference -> { Artist.count } => -1 do
        assert_raises LookupMetadata::Duplicate do
          LookupMetadata.new.perform duplicate, recursive: false
        end
      end
    end
  end

  test "album" do
    VCR.use_cassette("tadb/the_beatles") do
      artist = create :artist, name: "The Beatles", metadata: {idArtist: 111247}
      album = create :album, title: "The White Album", artist: artist

      assert_difference -> { album.tracks.count }, 30 do
        LookupMetadata.perform_now album
      end

      assert_instance_of Hash, album.metadata
      assert_equal "2213204", album.metadata["idAlbum"]
    end
  end
end
