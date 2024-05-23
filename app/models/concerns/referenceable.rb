module Referenceable
  extend ActiveSupport::Concern

  included do
    has_many :references, as: :record, dependent: :destroy
  end
end
