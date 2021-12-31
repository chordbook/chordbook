class Album < ApplicationRecord
  belongs_to :artist
  has_many :tracks

  {
    thumbnail: :strAlbumThumb,
    released: :intYearReleased,
    style: :strStyle,
    genre: :strGenre,
    description: :strDescriptionEN
  }.each do |accessor, key|
    define_method(accessor) do
      metadata && metadata[key.to_s]
    end
  end

  after_create { LookupMetadata.perform_later(self) unless metadata }
end
