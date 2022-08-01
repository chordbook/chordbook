require "test_helper"

class AssociateSongsheetMetadataTest < ActiveJob::TestCase
  test "associates with existing artist and track" do
    with_search Artist do
      track = create :track, title: "Somewhere Over the Rainbow"

      perform_enqueued_jobs only: AssociateSongsheetMetadata do
        songsheet = create :songsheet, title: track.title, metadata: {artist: track.artist.name}
        songsheet.reload

        assert_equal [track.artist], songsheet.artists
        assert_equal track, songsheet.track

        assert track.reload.has_songsheet?
      end
    end
  end

  test "ignores case when matching track title" do
    with_search Artist, Track do
      track = create :track
      perform_enqueued_jobs only: AssociateSongsheetMetadata do
        songsheet = create :songsheet, title: track.title.upcase, metadata: {artist: track.artist.name}
        songsheet.reload
        assert_equal track, songsheet.track
      end
    end
  end

  test "associates with multiple artists" do
    with_search Artist do
      artists = [create(:artist, name: "Johnny Cash"), create(:artist, name: "June Carter")]
      perform_enqueued_jobs only: AssociateSongsheetMetadata do
        songsheet = create :songsheet, metadata: {artist: artists.map(&:name).join(", ")}
        songsheet.reload
        assert_equal artists, songsheet.artists
      end
    end
  end

  test "associates with multiple artists and bands with `and` in the title" do
    with_search Artist do
      artists = [create(:artist, name: "The Undertones"), create(:artist, name: "Siouxsie and The Banshees")]
      perform_enqueued_jobs only: AssociateSongsheetMetadata do
        songsheet = create :songsheet, metadata: {artist: artists.map(&:name).join(", ")}
        songsheet.reload
        assert_equal artists, songsheet.artists
      end
    end
  end

  test "finds artist with similar name" do
    with_search Artist do
      artist = create :artist, name: "The Everly Brothers"

      perform_enqueued_jobs only: AssociateSongsheetMetadata do
        songsheet = create :songsheet, metadata: {artist: "Everly Brothers"}
        songsheet.reload
        assert_equal [artist], songsheet.artists
      end
    end
  end

  test "does not association track by different artist" do
    with_search Artist do
      artist = create :artist, name: "Trampled By Turtles"
      track = create :track, title: "Wildflowers", artist: artist

      perform_enqueued_jobs only: AssociateSongsheetMetadata do
        songsheet = create :songsheet, title: track.title, metadata: {artist: "Tom Petty"}
        songsheet.reload
        assert_nil songsheet.track
      end
    end
  end

  test "does not create duplicate artist" do
    with_search Artist do
      artist = create :artist, name: "The Beatles", metadata: {idArtist: "111247"}

      VCR.use_cassette("tadb/the_beatles") do
        perform_enqueued_jobs do
          assert_no_difference -> { Artist.count } do
            songsheet = create :songsheet, title: "Get Back", metadata: {artist: "Beatles"}
            assert_includes songsheet.reload.artists, artist
          end
        end
      end
    end
  end
end
