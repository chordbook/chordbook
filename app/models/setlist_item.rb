class SetlistItem < ApplicationRecord
  belongs_to :setlist
  belongs_to :songsheet

  acts_as_list scope: :setlist
end
