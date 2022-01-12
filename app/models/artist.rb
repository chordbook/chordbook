class Artist < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :artist_works, dependent: :destroy
  has_many :songsheets, through: :artist_works, source: :work, source_type: "Songsheet"

  after_create { LookupMetadata.perform_later(self, recursive: true) unless metadata }

  multisearchable against: [:name],
    additional_attributes: ->(record) { record.searchable_data }

  def searchable_data
    {
      weight: 0.8,
      data: {
        title: name,
        subtitle: nil,
        thumbnail: thumbnail
      }
    }
  end

  map_metadata(
    strArtistThumb: :thumbnail,
    strStyle: :style,
    strGenre: :genre,
    strBiographyEN: :biography
  )

  def banner
    %w[strArtistFanart strArtistWideThumb].map { |x| metadata[x] if metadata }.compact.first
  end
end
