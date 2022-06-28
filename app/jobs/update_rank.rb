# Updates `rank` column on all models
class UpdateRank < ApplicationJob
  queue_as :low

  WINDOW = 1.month

  def perform
    rank_songsheets
    rank_tracks
    rank_albums
    rank_artists
    rank_genres
  end

  # Rank songsheets by:
  # 1. Number of distinct recent players (all anonymous users count as 1)
  # 2. Number of track listeners
  # 3. Newest to oldest
  def rank_songsheets
    exec <<-EOQ, since: WINDOW.ago
      WITH
        players AS (
          SELECT (properties->>'songsheet_id')::uuid AS id, COUNT(DISTINCT user_id) AS count
          FROM ahoy_events
          WHERE name = 'play' AND time > :since
          GROUP BY properties->>'songsheet_id'
        ),
        ranked as (
          SELECT
            songsheets.id,
            ROW_NUMBER() OVER (
              ORDER BY
                players.count DESC NULLS LAST,
                tracks.listeners DESC NULLS LAST,
                songsheets.created_at DESC
            ) AS row
          FROM songsheets
          LEFT OUTER JOIN players ON songsheets.id = players.id
          LEFT OUTER JOIN tracks ON songsheets.track_id = tracks.id
        )
      UPDATE songsheets
      SET rank = ranked.row
      FROM ranked
      WHERE ranked.id = songsheets.id
    EOQ
  end

  # Rank tracks by:
  # 1. Number of distinct recent players
  # 2. Having at least 1 songsheet
  # 3. Number of listeners
  def rank_tracks
    exec <<-EOQ, since: WINDOW.ago
      WITH
        players AS (
          SELECT songsheets.track_id, COUNT(DISTINCT ahoy_events.user_id) AS count
          FROM ahoy_events
          JOIN songsheets ON songsheets.id = (properties->>'songsheet_id')::uuid
          WHERE name = 'play' AND time > :since
          GROUP BY 1
        ),
        ranked AS (
          SELECT
            tracks.id,
            ROW_NUMBER() over (ORDER BY
              players.count DESC NULLS LAST,
              CASE WHEN songsheets_count > 0 THEN 1 ELSE 2 END,
              tracks.listeners DESC NULLS LAST
            ) AS row
          FROM tracks
          LEFT OUTER JOIN players ON tracks.id = players.track_id
        )
      UPDATE tracks
      SET rank = ranked.row
      FROM ranked
      WHERE ranked.id = tracks.id
    EOQ
  end

  # Rank albums by average track rank
  def rank_albums
    exec <<-EOQ
      WITH
        avg_track_rank AS (
          SELECT album_id AS id, AVG(rank) AS rank
          FROM tracks
          GROUP BY album_id
        ),
        ranked AS (
          SELECT albums.id, ROW_NUMBER() over (ORDER BY avg_track_rank.rank) AS row
          FROM albums
          LEFT OUTER JOIN avg_track_rank ON avg_track_rank.id = albums.id
        )
      UPDATE albums
      SET rank = ranked.row
      FROM ranked
      WHERE ranked.id = albums.id
    EOQ
  end

  # Rank artists by:
  # 1. Number of distinct recent players
  # 2. Number of listeners
  def rank_artists
    exec <<-EOQ, since: WINDOW.ago
      WITH
        players AS (
          SELECT artist_works.artist_id, COUNT(DISTINCT ahoy_events.user_id) AS count
          FROM ahoy_events
          JOIN artist_works ON artist_works.work_id = (properties->>'songsheet_id')::uuid
            AND artist_works.work_type = 'Songsheet'
          WHERE name = 'play' AND time > :since
          GROUP BY 1
        ),
        ranked AS (
          SELECT
            artists.id,
            ROW_NUMBER() over (ORDER BY
              players.count DESC NULLS LAST,
              artists.listeners DESC NULLS LAST
            ) AS row
          FROM artists
          LEFT OUTER JOIN players ON artists.id = players.artist_id
        )
      UPDATE artists
      SET rank = ranked.row
      FROM ranked
      WHERE ranked.id = artists.id
    EOQ
  end

  # Rank artists by:
  # 1. Number of distinct recent players
  # 2. Number of listeners
  def rank_genres
    exec <<-EOQ, since: WINDOW.ago
      WITH
        players AS (
          SELECT tracks.genre_id, COUNT(DISTINCT user_id) AS count
          FROM ahoy_events
          JOIN songsheets ON songsheets.id = (properties->>'songsheet_id')::uuid
          JOIN tracks ON tracks.id = songsheets.track_id
          WHERE name = 'play' AND time > :since
          GROUP BY 1
        ),
        ranked AS (
          SELECT
            genres.id,
            ROW_NUMBER() over (ORDER BY
              players.count DESC NULLS LAST,
              genres.listeners DESC NULLS LAST
            ) AS row
          FROM genres
          LEFT OUTER JOIN players ON players.genre_id = genres.id
        )
      UPDATE genres
      SET rank = ranked.row
      FROM ranked
      WHERE ranked.id = genres.id
    EOQ
  end

  def exec(query, params = {})
    ApplicationRecord.connection.execute sanitize_sql(query, params)
  end

  def sanitize_sql(sql, params = {})
    ApplicationRecord.sanitize_sql([sql, params])
  end
end
