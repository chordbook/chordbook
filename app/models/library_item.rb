class LibraryItem < ApplicationRecord
  belongs_to :user
  belongs_to :item, polymorphic: true

  validates :item_type, inclusion: %w[Songsheet Artist Album Setlist]
end
