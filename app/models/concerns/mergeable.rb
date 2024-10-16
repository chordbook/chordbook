module Mergeable
  IGNORED_ATTRIBUTES = %w[id created_at updated_at]
  IGNORED_ASSOCIATIONS = %w[versions]

  # Merge the other object into this object
  def merge(other)
    raise ArgumentError, "Can't merge #{other.class} with #{self.class}" unless is_a?(other.class)

    other.attributes.without(IGNORED_ATTRIBUTES).each do |attr, value|
      if value.is_a?(Array)
        self[attr] = Array(self[attr]) + value
      elsif value.is_a?(Hash)
        self[attr] = (self[attr] || {}).merge(value)
      else
        self[attr] ||= value
      end
    end

    transaction do
      save!

      self.class.reflections.without(IGNORED_ASSOCIATIONS).each do |name, reflection|
        if reflection.is_a?(ActiveRecord::Reflection::HasOneReflection)
          other.send(name)&.update(reflection.foreign_key => id) unless send(name)
        elsif reflection.is_a?(ActiveRecord::Reflection::HasManyReflection)
          other.send(name).update_all(reflection.foreign_key => id)
        end
      end

      other.destroy
    end

    self
  end
end
