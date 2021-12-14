module AlphaPaginate
  extend ActiveSupport::Concern

  LETTERS = ["#"] + ("A".."Z").to_a

  included do
    scope :starts_with, ->(key, letter) {
      where(arel_table[key].matches(letter + "%"))
    }
  end

end
