class ApplicationRecord < ActiveRecord::Base
  include ShortIdentifier

  self.abstract_class = true
  before_save :strip_attrs

  private

  def strip_attrs
    changes.each do |attr, (_, value)|
      write_attribute attr, value.strip if value.is_a?(String)
    end
  end
end
