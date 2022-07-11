module Metadata
  extend ActiveSupport::Concern

  included do
    class_attribute :metadata_mapping, default: HashWithIndifferentAccess.new
    after_initialize { write_attribute(:metadata, {}) unless read_attribute(:metadata) }
    before_validation :move_metadata_to_attributes
  end

  class_methods do
    def map_metadata(mapping)
      mapping.each do |key, accessor|
        unless attribute_names.include?(accessor.to_s)
          define_method(accessor) do
            read_store_attribute(:metadata, key)
          end

          define_method("#{accessor}=") do |value|
            write_store_attribute(:metadata, key, value)
          end
        end
      end
      metadata_mapping.update(mapping)
    end

    def attach_from_metadata(mapping)
      mapping.each do |name, keys|
        has_one_attached name, &Metadata.method(:define_variants)

        define_method("download_#{name}_from_metadata") do
          url = metadata.slice(*keys.map(&:to_s)).values.map(&:presence).compact.first
          if url && (!send(name).attached? || send(name).metadata[:src] != url)
            DownloadAttachment.perform_later(self, name, url)
          end
        end

        after_save "download_#{name}_from_metadata".to_sym
      end
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

  def self.define_variants(attachable)
    ApplicationHelper::VARIANTS.each do |name, options|
      attachable.variant name, options
    end
  end
end
