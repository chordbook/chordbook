module AlphaPaginate
  extend ActiveSupport::Concern

  LETTERS = ["#"] + ("A".."Z").to_a

  included do
    scope :starts_with, ->(key, letter) {
      if letter == "#"
        where(arel_table[key].matches_regexp("^[0-9]"))
      else
        where(arel_table[key].matches(letter + "%"))
      end
    }
  end
end
