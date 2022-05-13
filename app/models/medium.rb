class Medium < ApplicationRecord
  belongs_to :record, polymorphic: true, touch: true
end
