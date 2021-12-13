class Album < ApplicationRecord
  belongs_to :artist

  after_create { LookupMetadata.perform_later(self) unless metadata }
end
