class ArtistWork < ApplicationRecord
  has_paper_trail

  belongs_to :artist
  belongs_to :work, polymorphic: true, touch: true
end
