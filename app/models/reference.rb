class Reference < ApplicationRecord
  belongs_to :record, polymorphic: true
  enum :source, musixmatch: "musixmatch", theaudiodb: "theaudiodb"

  before_save { record.reference_updated self }

  def data=(new_data)
    write_attribute :data, data.merge(new_data)
  end

  def data
    (read_attribute(:data) || {}).with_indifferent_access
  end
end
