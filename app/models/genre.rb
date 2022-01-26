class Genre < ApplicationRecord
  has_many :artists
  has_many :tracks
  has_many :albums

  has_one :example_track, -> { Track.order_by_popular }, class_name: "Track"
  has_one :example_artist, through: :example_track, class_name: "Artist", source: :artist

  scope :order_by_popular, -> { includes(:example_track, :example_track).order("tracks.listeners DESC NULLS LAST") }

  delegate :thumbnail, to: :example_artist, allow_nil: true
end
