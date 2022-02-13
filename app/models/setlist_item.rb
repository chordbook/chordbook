class SetlistItem < ApplicationRecord
  belongs_to :setlist, touch: true
  belongs_to :songsheet

  acts_as_list scope: :setlist
end
