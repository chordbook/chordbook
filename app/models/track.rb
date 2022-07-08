class Track < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_paper_trail

  belongs_to :artist
  belongs_to :album, optional: true
  belongs_to :genre, optional: true

  has_many :songsheets, dependent: :nullify

  scope :order_by_has_songsheet, -> {
    order(Arel.sql("CASE WHEN songsheets_count > 0 THEN 1 ELSE 2 END"))
  }
  scope :order_by_popular, -> { order("tracks.rank") }
  scope :order_by_number, -> { order(:number) }
  scope :with_songsheet, -> { where(songsheets_count: 1..) }

  pg_search_scope :title_like,
    against: :title,
    using: {
      trigram: {}
    },
    order_within_rank: "tracks.listeners DESC NULLS LAST, albums.released, albums.rank, tracks.rank"

  before_validation :associate_genre

  searchkick word_start: [:title, :everything], stem: false, callbacks: :async

  map_metadata(
    intTrackNumber: :number,
    intDuration: :duration,
    intTotalListeners: :listeners
  )

  def self.lookup(title)
    joins(:album).title_like(title).first
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

  def songsheet_was_added
    reindex(mode: :async) if Searchkick.callbacks?
    YoutubeLookup.perform_later self
  end

  def media
    (Array(super) + [metadata["strMusicVid"]]).compact.uniq
  end

  def associate_genre
    self.genre ||= if metadata["strGenre"].present?
      Genre.find_or_create_by!(name: metadata["strGenre"])
    else
      # Fall back to album genre
      album.genre
    end
  end
end
