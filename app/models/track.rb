class Track < ApplicationRecord
  include AlphaPaginate
  include Referenceable
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
  scope :search_import, -> { includes(:artist, {album: :image_attachment}) }

  pg_search_scope :title_like,
    against: :title,
    using: {
      trigram: {}
    },
    order_within_rank: "tracks.listeners DESC NULLS LAST, albums.released, albums.rank, tracks.rank"

  before_validation :associate_genre
  after_commit :musixmatch_lookup

  searchkick word_start: [:title, :everything], stem: false, callbacks: :async

  def self.lookup(title)
    joins(:album).title_like(title).first
  end

  def search_data
    {
      type: self.class,
      title: title,
      subtitle: artist.name,
      attachment_id: album.image_attachment&.id,
      everything: [title, artist.name, album.title],
      boost: 0.1
    }
  end

  def reference_updated(reference)
    if reference.theaudiodb?
      update({
        number: reference.data["intTrackNumber"],
        duration: reference.data["intDuration"],
        listeners: reference.data["intTotalListeners"],
        media: (Array(media) + [reference.data["strMusicVid"].presence]).compact.uniq,
        genre: Genre.named(reference.data["strGenre"])
      }.compact)
    end
  end

  def media
    Array(super)
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
  end

  def associate_genre
    # Fall back to album genre
    self.genre ||= album.genre
  end

  def musixmatch_lookup
    MusixMatch::MatchTrackJob.perform_later(self) if has_songsheet?
  end
end
