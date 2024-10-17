require "test_helper"

class AlbumTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  test "gets genre from theaudiodb reference" do
    album = create(:album)
    create(:reference, source: :theaudiodb, record: album, data: {strGenre: "R&B"})
    assert_equal album.reload.genre.name, "R&B"
  end

  test "falls back to artist genre" do
    artist = create(:artist, genre: create(:genre))
    album = create(:album, artist: artist)

    assert_equal artist.genre, album.genre
  end

  test "attaches image from metadata" do
    perform_enqueued_jobs only: DownloadAttachment do
      VCR.use_cassette("tadb/sting_the_bridge") do
        src = "https://www.theaudiodb.com/images/media/album/thumb/z9ld831637333639.jpg"
        album = create(:album)
        create(:reference, record: album, source: :theaudiodb, data: {strAlbumThumb: src})
        assert album.reload.image.attached?
        assert_equal src, album.image.metadata[:src]
      end
    end
  end

  test "prefers HQ image" do
    VCR.use_cassette("tadb/sting_the_bridge") do
      perform_enqueued_jobs only: DownloadAttachment do
        lq = "https://www.theaudiodb.com/images/media/album/thumb/z9ld831637333639.jpg"
        hq = "https://www.theaudiodb.com/images/media/album/thumbhq/hw4pbm1637333653.jpg"

        album = create(:album)
        create(:reference, record: album, source: :theaudiodb, data: {strAlbumThumb: lq, strAlbumThumbHQ: hq})
        assert album.reload.image.attached?
        assert_equal hq, album.image.metadata[:src]
      end
    end
  end
end
