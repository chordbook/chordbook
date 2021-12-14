class Artist < ApplicationRecord
  include AlphaPaginate

  has_many :albums
  has_many :tracks

  after_create { LookupMetadata.perform_later(self) unless metadata }

  # FIXME: set these in
  def thumbnail
    metadata&.fetch("strArtistThumb")
  end

  def banner
    %w[strArtistFanart strArtistWideThumb].map { |x| metadata&.fetch(x) }.compact.first
  end

  def style
    metadata&.fetch("strStyle")
  end

  def biography
    metadata&.fetch("strBiographyEN")
  end
end
