class Track < ApplicationRecord
  include AlphaPaginate
  include Metadata

  belongs_to :album, optional: true
  belongs_to :artist
  has_many :songsheets

  scope :order_by_popular, -> { order("tracks.listeners DESC NULLS LAST") }

  after_create :associate_songsheets

  map_metadata(
    intTrackNumber: :number,
    intDuration: :duration,
    intTotalListeners: :listeners
  )

  def has_songsheet!
    update_column :has_songsheet, true
  end

  def associate_songsheets
    Songsheet.joins(:artists)
      .where(artists: artist)
      .where(songsheets: {title: title})
      .update(track: self)
  end
end
