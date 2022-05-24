class UpdatePopularCounts < ApplicationJob
  def perform
    ApplicationRecord.connection.execute <<~EOQ
      UPDATE artists
      SET listeners = count.listeners, updated_at = NOW()
      FROM (
        SELECT artists.id, sum(tracks.listeners) as listeners
        FROM artists
        LEFT JOIN tracks
        ON tracks.artist_id = artists.id
        WHERE tracks.songsheets_count > 0
        GROUP BY artists.id
      ) AS count
      WHERE artists.id = count.id
    EOQ

    ApplicationRecord.connection.execute <<~EOQ
      UPDATE albums
      SET listeners = count.listeners, updated_at = NOW()
      FROM (
        SELECT albums.id, sum(tracks.listeners) as listeners
        FROM albums
        LEFT JOIN tracks
        ON tracks.album_id = albums.id
        WHERE tracks.songsheets_count > 0
        GROUP BY albums.id
      ) AS count
      WHERE albums.id = count.id
    EOQ

    # These fields aren't currently indexed
    Searchkick.callbacks(false) do
      # There aren't as many genres as artists/albums, so just iterate over them to udpate
      Genre.find_each do |genre|
        genre.update(
          thumbnail: genre.artists.first&.thumbnail,
          listeners: genre.tracks.sum(:listeners) || 0
        )
      end
    end
  end
end
