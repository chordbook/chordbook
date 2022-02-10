class Songsheet < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  belongs_to :track, optional: true
  has_many :artist_works, as: :work
  has_many :artists, through: :artist_works

  scope :order_by_popular, -> { includes(:track).order("tracks.listeners DESC NULLS LAST") }
  scope :recent, -> { order(created_at: :desc) }

  validates :title, presence: true

  before_save :associate_metadata
  after_save :mark_track

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

  private

  def associate_metadata
    if metadata["artist"]
      self.artists = Array(metadata["artist"]).map { |a| a.split(/\s*,\s*/) }.flatten.map do |name|
        Artist.find_or_initialize_by(name: name.strip)
      end
    end

    self.track = Track.title_like(title).where(artist_id: artists.map(&:id)).order_by_popular.first
  end

  def mark_track
    track&.has_songsheet!
  end
end
