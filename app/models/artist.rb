class Artist < ApplicationRecord
  include AlphaPaginate
  include Metadata
  include PgSearch::Model

  has_paper_trail

  has_many :albums, dependent: :destroy
  has_many :tracks, dependent: :destroy
  has_many :artist_works, dependent: :destroy
  has_many :songsheets, through: :artist_works, source: :work, source_type: "Songsheet"
  belongs_to :genre, optional: true
  has_many :library_items, as: :item, dependent: :destroy

  before_validation :associate_genre

  searchkick word_start: [:title], stem: false, callbacks: :async
  scope :order_by_alphabetical, -> { order("UPPER(name)") }
  scope :order_by_popular, -> { order("artists.rank") }

  image_from_metadata :strArtistThumbHQ, :strArtistThumb

  map_metadata(
    strArtist: :name,
    strArtistThumb: :thumbnail,
    strStyle: :style,
    strBiographyEN: :biography
  )

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

    [artists, unknown]
  end

  def search_data
    {
      type: self.class,
      title: name,
      thumbnail: thumbnail,
      everything: [name, metadata["strArtistAlternate"].presence].compact,
      boost: 2.0
    }
  end

  def banner
    %w[strArtistFanart strArtistWideThumb].map { |x| metadata[x] if metadata }.compact.first
  end

  def associate_genre
    return if metadata["strGenre"].blank?
    self.genre ||= Genre.find_or_create_by!(name: metadata["strGenre"])
  end
end
