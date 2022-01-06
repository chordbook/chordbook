module Metadata
  extend ActiveSupport::Concern

  included do
    class_attribute :metadata_mapping, default: HashWithIndifferentAccess.new
    before_validation :move_metadata_to_attributes
  end

  class_methods do
    def map_metadata(mapping)
      mapping.each do |key, accessor|
        unless attribute_names.include?(accessor.to_s)
          define_method(accessor) do
            read_store_attribute(:metadata, key)
          end
        end
      end
      metadata_mapping.update(mapping)
    end
  end

  def move_metadata_to_attributes
    return unless metadata
    metadata.each do |key, value|
      attr_name = (metadata_mapping[key] || key).to_s
      if attribute_names.include?(attr_name) && metadata[key]
        write_attribute attr_name, read_store_attribute(:metadata, key)
        self.metadata = metadata.without(key)
      end
    end
  end
end
