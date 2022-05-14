class Medium < ApplicationRecord
  belongs_to :record, polymorphic: true, touch: true

  has_paper_trail
end
