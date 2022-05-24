class LibraryItem < ApplicationRecord
  belongs_to :user
  belongs_to :item, polymorphic: true

  validates :item_type, inclusion: %w[Songsheet Artist Album Setlist]
  validates_uniqueness_of :user_id, scope: [:item_id, :item_type]
end
