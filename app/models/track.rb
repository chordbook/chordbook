class Track < ApplicationRecord
  include AlphaPaginate

  belongs_to :album, optional: true
  belongs_to :artist
end
