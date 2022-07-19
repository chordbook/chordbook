class Genre < ApplicationRecord
  has_many :artists, -> { Artist.order_by_popular }, dependent: :nullify
  has_many :tracks, -> { Track.order_by_popular }, dependent: :nullify
  has_many :albums, -> { Album.order_by_popular }, dependent: :nullify

  has_paper_trail

  has_one_attached :image do |attachable|
    attachable.variant :medium, resize_to_fill: [500, 375], format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 90}
  end

  scope :order_by_popular, -> { order("genres.rank") }
end
