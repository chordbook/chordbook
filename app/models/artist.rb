class Artist < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_paper_trail

  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :artist_works, dependent: :destroy
  has_many :songsheets, through: :artist_works, source: :work, source_type: "Songsheet"
  belongs_to :genre, optional: true

  before_validation :associate_genre
  after_commit(on: :create) { LookupMetadata.perform_later(self) }

  searchkick word_start: [:title], stem: false, callbacks: :async
  scope :verified, -> { where(verified: true) }
  scope :order_by_alphabetical, -> { order("UPPER(name)") }
  scope :order_by_popular, -> { order("artists.rank") }

  def self.lookup(name)
    search(name, boost_by: [:boost], fields: ["everything"]).first
  end

  def search_data
    {
      type: self.class,
      title: name,
      thumbnail: thumbnail,
      everything: [name, metadata["strArtistAlternate"].presence].compact,
      boost: verified ? 2.0 : 1.0
    }
  end

  map_metadata(
    strArtist: :name,
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
