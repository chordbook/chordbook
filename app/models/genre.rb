class Genre < ApplicationRecord
  has_many :artists, -> { Artist.order_by_popular }
  has_many :tracks, -> { Track.order_by_popular }
  has_many :albums, -> { Album.order_by_popular }

  has_paper_trail

  scope :order_by_popular, -> { order("genres.rank") }
end
