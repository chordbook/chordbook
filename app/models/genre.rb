class Genre < ApplicationRecord
  has_many :artists, -> { Artist.order_by_popular }, dependent: :nullify
  has_many :tracks, -> { Track.order_by_popular }, dependent: :nullify
  has_many :albums, -> { Album.order_by_popular }, dependent: :nullify

  has_paper_trail

  has_one_attached :image, &Metadata.method(:define_variants)

  scope :order_by_popular, -> { order("genres.rank") }
end
