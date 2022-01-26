class ArtistWork < ApplicationRecord
  belongs_to :artist
  belongs_to :work, polymorphic: true
end
