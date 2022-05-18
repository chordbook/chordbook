class Album < ApplicationRecord
  include Metadata
  include PgSearch::Model

  belongs_to :artist
  belongs_to :genre, optional: true
  has_many :tracks, -> { Track.order_by_number }

  before_validation :associate_genre

  scope :order_by_popular, -> { order("albums.score DESC NULLS LAST") }
  scope :order_by_released, ->(dir = :desc) { order(released: "#{dir} NULLS LAST") }

  searchkick word_start: [:title, :everything]

  scope :search_import, -> { includes(:artist) }

  def search_data
    {
      type: self.class,
      title: title,
      thumbnail: thumbnail,
      subtitle: artist.name,
      everything: [title, artist.name],
      boost: 1.0
    }
  end

  map_metadata(
    strAlbumThumb: :thumbnail,
    intYearReleased: :released,
    strStyle: :style,
    strDescriptionEN: :description,
    intScore: :score
  )

  def associate_genre
    return if metadata["strGenre"].blank?
    self.genre = Genre.find_or_create_by!(name: metadata["strGenre"])
  end
end
