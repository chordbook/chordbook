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
    order(Arel.sql("CASE WHEN songsheets_count > 0 THEN 1 ELSE 2 END"))
  }
  scope :order_by_popular, -> {
    order_by_has_songsheet.order("tracks.listeners DESC NULLS LAST")
  }
  scope :order_by_number, -> { order(:number) }
  scope :with_songsheet, -> { where(songsheets_count: 1..) }

  pg_search_scope :title_like,
    against: :title,
    using: {
      trigram: {}
    },
    order_within_rank: "tracks.listeners DESC NULLS LAST, albums.released, albums.score DESC NULLS LAST, tracks.id"

  before_validation :associate_genre
  after_save :associate_media

  searchkick word_start: [:title, :everything], stem: false, callbacks: :async

  map_metadata(
    intTrackNumber: :number,
    intDuration: :duration,
    intTotalListeners: :listeners
  )

  def self.lookup(title)
    joins(:album).title_like(title).order_by_popular.first
  end

  scope :search_import, -> { includes(:artist, :album) }

  def search_data
    {
      type: self.class,
      title: title,
      subtitle: artist.name,
      thumbnail: album.thumbnail,
      everything: [title, artist.name, album.title],
      boost: 0.75
    }
  end

  # No need to index tracks with songsheets
  def should_index?
    !has_songsheet?
  end

  def has_songsheet?
    songsheets_count > 0
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
