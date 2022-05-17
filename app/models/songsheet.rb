class Songsheet < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_paper_trail

  belongs_to :track, optional: true, counter_cache: true
  has_many :artist_works, as: :work
  has_many :artists, through: :artist_works
  has_many :media, as: :record

  scope :order_by_popular, -> {
    includes(:track).order("tracks.listeners DESC NULLS LAST").order_by_recent
  }
  scope :order_by_recent, -> { order(created_at: :desc) }
  scope :order_by_todo, -> { order(Arel.sql("track_id NULLS FIRST, updated_at ASC")) }

  validates :title, presence: true

  before_save :associate_metadata
  after_commit { track&.reload&.reindex if Searchkick.callbacks? }

  searchkick word_start: [:title, :everything]

  scope :search_import, -> { includes(track: :album) }

  def search_data
    {
      title: title,
      artist: metadata["artist"],
      album: track&.album&.title,
      # Because searchkick doesn't support `cross_fields`
      # https://github.com/ankane/searchkick/pull/871
      everything: [title, metadata["artist"], track&.album&.title].compact.flatten,
      boost: 3
    }
  end

  def all_media
    Medium.where(record: [self, track].compact)
  end

  private

  def associate_metadata
    artist_names = Array(metadata["artist"]).map { |a| a.split(/\s*,\s*/) }.flatten
    if artist_names.any?
      self.artists = artist_names.map { |name| Artist.lookup(name) || Artist.new(name: name.strip) }
    end

    track = Track.where(artist_id: artist_ids.compact).lookup(title)
    self.track = track if track
  end
end
