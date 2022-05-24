class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  before_save :strip_attrs

  def uid
    to_global_id.to_s
  end

  def self.locate(uid)
    GlobalID::Locator.locate uid
  end

  private

  def strip_attrs
    changes.each do |attr, (_, value)|
      write_attribute attr, value.strip if value.is_a?(String)
    end
  end
end
