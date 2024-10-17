module Referenceable
  extend ActiveSupport::Concern

  included do
    has_many :references, as: :record, dependent: :destroy
    has_one :theaudiodb_reference, -> { theaudiodb }, class_name: "Reference", as: :record
  end
end
