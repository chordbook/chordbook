class Genre < ApplicationRecord
  has_many :artists, -> { Artist.order_by_popular }
  has_many :tracks, -> { Track.with_songsheet.order_by_popular }
  has_many :albums, -> { Album.order_by_popular }

  has_paper_trail

  has_one :example_track, -> { Track.order_by_popular }, class_name: "Track"
  has_one :example_artist, through: :example_track, class_name: "Artist", source: :artist

  scope :order_by_popular, -> { order("genres.rank") }
end
