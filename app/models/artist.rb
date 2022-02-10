class Artist < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :artist_works, dependent: :destroy
  has_many :songsheets, through: :artist_works, source: :work, source_type: "Songsheet"
  belongs_to :genre, optional: true

  before_validation :associate_genre
  after_commit(on: :create) { LookupMetadata.perform_later(self) }

  multisearchable against: [:name],
    additional_attributes: ->(record) { record.searchable_data }

  pg_search_scope :name_like,
    against: :name,
    using: {
      trigram: {}
    },
    ranked_by: ":trigram * CASE WHEN verified THEN 1.0 ELSE 0.75 END"

  scope :verified, -> { where(verified: true) }

  def self.lookup(name)
    name_like(name).first
  end

  def searchable_data
    {
      weight: verified ? 0.8 : 0.5,
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
    strBiographyEN: :biography
  )

  def banner
    %w[strArtistFanart strArtistWideThumb].map { |x| metadata[x] if metadata }.compact.first
  end

  def associate_genre
    return if metadata["strGenre"].blank?
    self.genre = Genre.find_or_create_by!(name: metadata["strGenre"])
  end
end
