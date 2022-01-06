class Artist < ApplicationRecord
  include AlphaPaginate
  include Metadata

  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :artist_works, dependent: :destroy
  has_many :songsheets, through: :artist_works, source: :work, source_type: "Songsheet"

  after_create { LookupMetadata.perform_later(self, recursive: true) unless metadata }

  map_metadata(
    strArtistThumb: :thumbnail,
    strStyle: :style,
    strGenre: :genre,
    strBiographyEN: :biography
  )

  def banner
    %w[strArtistFanart strArtistWideThumb].map { |x| metadata&.fetch(x) }.compact.first
  end
end
