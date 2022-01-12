class Track < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  belongs_to :album, optional: true
  belongs_to :artist
  has_many :songsheets

  scope :order_by_popular, -> { order("tracks.listeners DESC NULLS LAST") }

  after_create :associate_songsheets

  multisearchable additional_attributes: ->(record) { {data: record.searchable_data} },
    unless: :has_songsheet? # No need to index tracks with songsheets

  map_metadata(
    intTrackNumber: :number,
    intDuration: :duration,
    intTotalListeners: :listeners
  )

  def searchable_text
    [title, artist&.name, album&.title].compact.join(" ")
  end

  def searchable_data
    {
      title: title,
      subtitle: artist.name,
      thumbnail: album&.thumbnail
    }
  end

  def has_songsheet!
    update_attribute :has_songsheet, true
  end

  def associate_songsheets
    Songsheet.joins(:artists)
      .where(artists: artist)
      .where(songsheets: {title: title})
      .update(track: self)
  end
end
