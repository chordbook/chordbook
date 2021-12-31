class Track < ApplicationRecord
  include AlphaPaginate

  belongs_to :album, optional: true
  belongs_to :artist

  scope :order_by_popular, -> {
    # FIXME: store in indexed field
    order(Arel.sql("NULLIF(metadata->>'intTotalListeners', '')::int ASC NULLS LAST"))
  }

  {
    number: :intTrackNumber,
    duration: :intDuration
  }.each do |accessor, key|
    define_method(accessor) do
      metadata && metadata[key.to_s]
    end
  end
end
