class Setlist < ApplicationRecord
  has_many :setlist_items, -> { order(position: :asc) }, dependent: :destroy
  has_many :songsheets, through: :setlist_items
  has_many :tracks, through: :songsheets
  has_many :albums, through: :tracks

  scope :order_by_recent, -> { order(updated_at: :desc) }

  def thumbnails
    albums.limit(4).map(&:thumbnail)
  end
end
