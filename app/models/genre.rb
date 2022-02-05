class Genre < ApplicationRecord
  has_many :artists
  has_many :tracks
  has_many :albums

  has_one :example_track, -> { Track.order_by_popular }, class_name: "Track"
  has_one :example_artist, through: :example_track, class_name: "Artist", source: :artist

  scope :order_by_popular, -> { order("listeners DESC NULLS LAST") }
end
