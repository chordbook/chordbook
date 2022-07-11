class Songsheet < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_paper_trail

  belongs_to :track, optional: true, counter_cache: true
  has_many :artist_works, as: :work, dependent: :destroy
  has_many :artists, through: :artist_works
  has_many :library_items, as: :item, dependent: :destroy

  scope :order_by_popular, -> { order("songsheets.rank") }
  scope :order_by_recent, -> { order(created_at: :desc) }
  scope :order_by_todo, -> { order(Arel.sql("track_id NULLS FIRST, updated_at ASC")) }

  validates :title, presence: true
  validates :format, presence: true

  class_attribute :perform_metadata_lookup, default: true

  after_initialize :set_defaults
  after_commit(if: :perform_metadata_lookup) { AssociateSongsheetMetadata.perform_later self }
  after_commit { track&.songsheet_was_added if track_id_previously_changed? }

  searchkick word_start: [:title, :everything], stem: false, callbacks: :async

  scope :search_import, -> { includes(track: :album) }

  def search_data
    {
      type: self.class,
      title: title,
      subtitle: Array(metadata["artist"]).to_sentence,
      thumbnail: track&.album&.thumbnail,
      # Because searchkick doesn't support `cross_fields`
      # https://github.com/ankane/searchkick/pull/871
      everything: [title, metadata["artist"] || metadata["subtitle"], track&.album&.title].compact.flatten,
      boost: 3.0
    }
  end

  def all_media
    (Array(metadata["media"]) + Array(track&.media)).flatten.compact.uniq
  end

  private

  def set_defaults
    self.format ||= "ChordPro"
  end
end
