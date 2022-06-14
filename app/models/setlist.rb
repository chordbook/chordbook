class Setlist < ApplicationRecord
  has_paper_trail

  belongs_to :user
  has_many :items, -> { order(position: :asc) }, class_name: "SetlistItem", dependent: :destroy
  has_many :songsheets, through: :items
  has_many :tracks, through: :songsheets
  has_many :albums, through: :tracks

  after_create { user.library.add self }

  scope :order_by_recent, -> { order(updated_at: :desc) }

  def thumbnails
    albums.limit(4).map(&:thumbnail)
  end
end
