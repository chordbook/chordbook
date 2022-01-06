class Songsheet < ApplicationRecord
  include AlphaPaginate
  include Metadata

  belongs_to :track, optional: true
  has_many :artist_works, as: :work
  has_many :artists, through: :artist_works

  scope :recent, -> { order(created_at: :desc) }

  validates :title, presence: true

  before_save :associate_metadata

  private

  def associate_metadata
    self.artists = Array(metadata["artist"]).map do |name|
      Artist.find_or_initialize_by(name: name)
    end

    self.track ||= Track.find_by(title: title, artist_id: artists.map(&:id))

    track&.has_songsheet!
  end
end
