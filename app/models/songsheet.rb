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
  after_commit { track&.reload&.update_pg_search_document }

  multisearchable additional_attributes: ->(record) { record.searchable_data }

  def searchable_text
    [
      title,
      artists.map(&:name),
      track&.album&.title
    ].flatten.compact.join(" ")
  end

  def searchable_data
    {
      weight: 1.0,
      data: {
        title: title,
        subtitle: metadata["artist"] && "by #{Array(metadata["artist"]).to_sentence}",
        thumbnail: track&.album&.thumbnail
      }
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
