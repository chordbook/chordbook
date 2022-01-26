class Album < ApplicationRecord
  include Metadata
  include PgSearch::Model

  belongs_to :artist
  belongs_to :genre, optional: true
  has_many :tracks

  before_validation :associate_genre

  scope :order_by_popular, -> { order("albums.score DESC NULLS LAST") }
  scope :order_by_released, ->(dir = :desc) { order(released: "#{dir} NULLS LAST") }

  multisearchable additional_attributes: ->(record) { record.searchable_data }

  def searchable_text
    [title, artist&.name].compact.join(" ")
  end

  def searchable_data
    {
      weight: 0.5,
      data: {
        title: title,
        subtitle: artist.name,
        thumbnail: thumbnail
      }
    }
  end

  map_metadata(
    strAlbumThumb: :thumbnail,
    intYearReleased: :released,
    strStyle: :style,
    strDescriptionEN: :description
  )

  def associate_genre
    return unless metadata["strGenre"]
    self.genre = Genre.find_or_create_by!(name: metadata["strGenre"])
  end
end
