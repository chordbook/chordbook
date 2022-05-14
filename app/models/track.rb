class Track < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_paper_trail

  belongs_to :artist
  belongs_to :album, optional: true
  belongs_to :genre, optional: true

  has_many :songsheets, dependent: :nullify
  has_many :media, as: :record

  scope :order_by_has_songsheet, -> {
    order(Arel.sql("CASE WHEN has_songsheet THEN 1 ELSE 2 END"))
  }
  scope :order_by_popular, -> {
    order_by_has_songsheet.order("tracks.listeners DESC NULLS LAST")
  }
  scope :order_by_number, -> { order(:number) }
  scope :with_songsheet, -> { where(has_songsheet: true) }

  pg_search_scope :title_like,
    against: :title,
    using: {
      trigram: {}
    },
    order_within_rank: "tracks.listeners DESC NULLS LAST, albums.released, albums.score DESC NULLS LAST, tracks.id"

  before_validation :associate_genre
  after_create :associate_songsheets
  after_save :associate_media

  multisearchable additional_attributes: ->(record) { record.searchable_data },
    unless: :has_songsheet? # No need to index tracks with songsheets

  map_metadata(
    intTrackNumber: :number,
    intDuration: :duration,
    intTotalListeners: :listeners
  )

  def self.lookup(title)
    joins(:album).title_like(title).order_by_popular.first
  end

  def searchable_text
    [title, artist&.name, album&.title].compact.join(" ")
  end

  def searchable_data
    {
      weight: 0.25,
      data: {
        title: title,
        subtitle: artist.name,
        thumbnail: album&.thumbnail
      }
    }
  end

  def has_songsheet!
    update_attribute :has_songsheet, true
  end

  def associate_songsheets
    Songsheet.joins(:artists)
      .where(artists: artist)
      .where(songsheets: {title: title})
      .each(&:save) # Just saving should cause songsheet to re-associate
  end

  def associate_genre
    return if metadata["strGenre"].blank?
    self.genre = Genre.find_or_create_by!(name: metadata["strGenre"])
  end

  def associate_media
    return if metadata["strMusicVid"].blank?
    media.find_or_create_by(uri: metadata["strMusicVid"])
  end
end
