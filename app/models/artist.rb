class Artist < ApplicationRecord
  include AlphaPaginate
  include Referenceable
  include Viewable

  has_paper_trail

  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :artist_works, dependent: :destroy
  has_many :songsheets, through: :artist_works, source: :work, source_type: "Songsheet"
  belongs_to :genre, optional: true
  has_many :library_items, as: :item, dependent: :destroy

  searchkick word_start: [:title], stem: false, callbacks: :async
  scope :order_by_alphabetical, -> { order("UPPER(artists.name)") }
  scope :order_by_popular, -> { order("artists.rank") }
  scope :search_import, -> { includes(:image_attachment) }
  scope :with_attachments, -> { preload(image_attachment: {blob: :variant_records}) }

  has_one_attached :image do |attachable|
    options = {
      format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 90}
    }

    attachable.variant :small, resize_to_fill: [100, 100], **options
    attachable.variant :medium, resize_to_fill: [400, 400], **options
    attachable.variant :large, resize_to_fill: [800, 800], **options
  end

  has_one_attached :banner do |attachable|
    attachable.variant :medium, resize_to_fit: [1280, 720], format: :jpeg,
      saver: {subsample_mode: "on", strip: true, interlace: true, quality: 90}
  end

  # Look up a single artist by name
  def self.lookup(name)
    search(name, boost_by: [:boost], fields: ["everything"]).first
  end

  # Look up one or more artists, splitting by common conjunctions if necessary
  # Returns [ known, unknown ]
  def self.lookup_all(names)
    unknown = []
    artists = []

    Array(names).each do |name|
      artist = Artist.lookup(name.gsub(/^by /, ""))

      # Artist found, nothing else to do
      artists << artist && next if artist

      # No artist by that name. Is it multiple artists?
      split_names = name.split(/,?\s+and\s+|,|&/i).map(&:strip)

      if split_names.length > 1
        # Recursive lookup on each name
        now_found, still_unknown = lookup_all(split_names)

        # Add original name if any are still unknown
        unknown << name if still_unknown.length > 0

        # Save the results
        unknown += still_unknown
        artists += now_found
      else
        unknown << name
      end
    end.flatten.compact

    [artists.uniq, unknown]
  end

  def search_data
    {
      type: self.class,
      title: name,
      attachment_id: image_attachment&.id,
      everything: [name, references.theaudiodb.first&.data&.dig("strArtistAlternate").presence].compact,
      boost: 2.0
    }
  end

  def biography
    references.theaudiodb.first&.data&.dig("strBiographyEN")
  end

  def reference_updated(reference)
    if reference.theaudiodb?
      update!({
        name: reference.data["strArtist"],
        style: reference.data["strStyle"],
        genre: Genre.named(reference.data["strGenre"]),
        updated_at: Time.now
      }.compact)

      DownloadAttachment.perform_later self, :image, reference.data.values_at("strArtistThumbHQ", "strArtistThumb")
      DownloadAttachment.perform_later self, :banner, reference.data.values_at("strArtistFanart", "strArtistWideThumb")
    end
  end
end
