class Songsheet < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model
  include Viewable

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
  scope :includes_track, -> {
    includes(
      track: [
        :artist,
        {
          album: {
            artist: {image_attachment: {blob: :variant_records}},
            image_attachment: {blob: :variant_records}
          }
        }
      ]
    )
  }

  validates :title, presence: true

  class_attribute :perform_metadata_lookup, default: true

  before_validation :downcase_metadata_keys
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

  def duration
    if metadata["duration"]
      Duration.parse(metadata["duration"])
    elsif track&.duration
      Duration.new(track.duration)
    end
  end

  private

  def downcase_metadata_keys
    metadata.transform_keys!(&:downcase)
  end
end
