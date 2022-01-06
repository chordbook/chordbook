class Album < ApplicationRecord
  include Metadata

  belongs_to :artist
  has_many :tracks

  scope :order_by_popular, -> { order("albums.score DESC NULLS LAST") }
  scope :order_by_released, ->(dir = :desc) { order(released: "#{dir} NULLS LAST") }

  map_metadata(
    strAlbumThumb: :thumbnail,
    intYearReleased: :released,
    strStyle: :style,
    strGenre: :genre,
    strDescriptionEN: :description
  )

  after_create { LookupMetadata.perform_later(self) unless metadata }
end
