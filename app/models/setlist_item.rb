class SetlistItem < ApplicationRecord
  belongs_to :setlist, touch: true
  belongs_to :songsheet

  has_paper_trail
  acts_as_list scope: :setlist
end
