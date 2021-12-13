require "test_helper"

class LookupMetadataTest < ActiveJob::TestCase
  test "new artist" do
    VCR.use_cassette("tadb/the_beatles") do
      artist = Artist.create! name: "The Beatles"

      assert_difference -> { artist.albums.count }, 50 do
        LookupMetadata.perform_now artist
      end

      assert_instance_of Hash, artist.metadata
      assert_equal "111247", artist.metadata["idArtist"]
      assert_enqueued_jobs 52
    end
  end

  test "update existing artist" do
    artist = Artist.create! name: "The Beatles", metadata: {idArtist: 111247, intFormedYear: 1900}
    artist.reload # Reload so it is not a new record
    assert !artist.id_previously_changed?

    VCR.use_cassette("tadb/the_beatles") do
      # Should not recursively sync on update
      assert_difference -> { artist.albums.count }, 0 do
        LookupMetadata.perform_now artist
      end

      assert_instance_of Hash, artist.metadata
      assert_equal "111247", artist.metadata["idArtist"]
      assert_equal "1957", artist.metadata["intFormedYear"]
    end
  end

  test "album" do
    VCR.use_cassette("tadb/the_beatles/the_white_album") do
      artist = Artist.create! name: "The Beatles", metadata: {idArtist: 111247}
      album = Album.create! title: "The White Album", artist: artist

      assert_difference -> { album.tracks.count }, 30 do
        LookupMetadata.perform_now album
      end

      assert_instance_of Hash, album.metadata
      assert_equal "2213204", album.metadata["idAlbum"]
    end
  end
end
