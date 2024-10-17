class Album < ApplicationRecord
  include Referenceable
  include Viewable

  belongs_to :artist
  belongs_to :genre, optional: true
  has_many :tracks, -> { Track.order_by_number }, dependent: :destroy
  has_many :library_items, as: :item, dependent: :destroy

  before_validation :validate_released_year
  before_save :default_to_artist_genre

  scope :order_by_popular, -> { order("albums.rank") }
  scope :order_by_released, ->(dir = :desc) { order(released: "#{dir} NULLS LAST") }

  searchkick word_start: [:title, :everything], stem: false, callbacks: :async

  scope :search_import, -> { includes(:artist, :image_attachment) }
  scope :with_attachments, -> { includes(image_attachment: {blob: :variant_records}) }

  has_one_attached :image do |attachable|
    options = {
      format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 90}
    }

    attachable.variant :small, resize_to_fill: [100, 100], **options
    attachable.variant :medium, resize_to_fill: [200, 200], **options
    attachable.variant :large, resize_to_fill: [500, 500], **options
  end

  def reference_updated(reference)
    if reference.theaudiodb?
      update({
        title: reference.data["strAlbum"],
        style: reference.data["strStyle"],
        description: reference.data["strDescriptionEN"],
        score: reference.data["intScore"],
        released: reference.data["intYearReleased"],
        genre: Genre.named(reference.data["strGenre"])
      }.compact)

      DownloadAttachment.perform_later self, :image, reference.data.values_at("strAlbumThumbHQ", "strAlbumThumb")
    end
  end

  def search_data
    {
      type: self.class,
      title: title,
      attachment_id: image_attachment&.id,
      subtitle: artist.name,
      everything: [title, artist.name],
      boost: 1.0
    }
  end

  def default_to_artist_genre
    self.genre ||= artist.genre
  end

  def validate_released_year
    # Source data is bad for a handful of albums
    self.released = nil unless (1900..Date.today.year).cover?(released)
  end
end
