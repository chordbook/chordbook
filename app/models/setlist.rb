class Setlist < ApplicationRecord
  include Viewable

  has_paper_trail

  belongs_to :user
  has_many :items, -> { order(position: :asc) }, class_name: "SetlistItem", dependent: :destroy,
    after_add: :update_thumbnails, after_remove: :update_thumbnails
  has_many :songsheets, through: :items
  has_many :tracks, through: :songsheets
  has_many :artists, through: :tracks
  has_many :artist_images, through: :artists, source: :image_attachment
  has_many :library_items, as: :item, dependent: :destroy

  has_many_attached :thumbnails do |attachable|
    Album.attachment_reflections["image"].named_variants.each do |name, variant|
      attachable.variant(name, variant.transformations)
    end
  end

  after_create { user.library.add self }

  scope :order_by_recent, -> { order(updated_at: :desc) }
  scope :order_by_popular, -> { order("setlists.rank") }
  scope :with_attachments, -> { includes(thumbnails_attachments: {blob: :variant_records}) }

  def update_thumbnails(_ = nil)
    images = artist_images
      .select("active_storage_attachments.*, min(setlist_items.position) AS min_position")
      .includes(:blob)
      .group("active_storage_attachments.id")
      .reorder("min_position ASC").limit(9)

    update thumbnails: images.map(&:blob)
  end
end
