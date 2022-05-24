class LibraryItem < ApplicationRecord
  belongs_to :user
  belongs_to :item, polymorphic: true
end
