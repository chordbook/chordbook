class Songsheet < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_paper_trail

  belongs_to :track, optional: true, counter_cache: true
  has_many :artist_works, as: :work, dependent: :destroy
  has_many :artists, through: :artist_works
  has_many :library_items, as: :item, dependent: :destroy
  has_many :setlist_items, dependent: :destroy

  scope :order_by_popular, -> { order("songsheets.rank") }
  scope :order_by_recent, -> { order(created_at: :desc) }
  scope :order_by_todo, -> { order(Arel.sql("track_id NULLS FIRST, updated_at ASC")) }
  scope :search_import, -> { includes(track: {album: :image_attachment}) }
  scope :played, -> {
    joins(
      "JOIN (
        SELECT uuid(ahoy_events.properties->>'songsheet_id') AS songsheet_id, user_id, MAX(time) AS time
        FROM ahoy_events
        GROUP BY songsheet_id, user_id
      ) plays ON plays.songsheet_id = songsheets.id"
    )
      .order("plays.time DESC")
  }
  scope :played_by, ->(user) { played.where("plays.user_id = ?", user) }

  validates :title, presence: true

  class_attribute :perform_metadata_lookup, default: true

  after_commit(if: :perform_metadata_lookup) { AssociateSongsheetMetadata.perform_later self }
  after_commit { track&.songsheet_was_added if track_id_previously_changed? }

  searchkick word_start: [:title, :everything], stem: false, callbacks: :async

  def search_data
    {
      type: self.class,
      title: title,
      subtitle: Array(metadata["artist"]).to_sentence,
      attachment_id: track&.album&.image_attachment&.id,
      # Because searchkick doesn't support `cross_fields`
      # https://github.com/ankane/searchkick/pull/871
      everything: [title, metadata["artist"] || metadata["subtitle"], track&.album&.title].compact.flatten,
      boost: 3.0
    }
  end

  def all_media
    (Array(metadata["media"]) + Array(track&.media)).flatten.compact.uniq
  end
end
