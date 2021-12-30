class Songsheet < ApplicationRecord
  belongs_to :track, optional: true
  has_many :artist_works, as: :work
  has_many :artists, through: :artist_works

  scope :recent, -> { order(created_at: :desc) }
  store_accessor :metadata, :title, :subtitle, :artist

  validates :title, :subtitle, presence: true

  before_save :associate_track_and_artists
  after_create { LookupSongsheetMetadata.perform_later self }

  def subtitle
    super || artist
  end

  private

  def associate_track_and_artists
    self.artists = Array(metadata["artist"]).map { |name| Artist.find_by(name: name) }.compact
    self.track ||= Track.find_by(title: title, artist_id: artists.map(&:id))
    true
  end
end
