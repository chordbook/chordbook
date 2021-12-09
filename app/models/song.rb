class Song < ApplicationRecord
  scope :recent, -> { order(created_at: :desc) }
  store_accessor :metadata, :title, :subtitle, :artist
  validates :title, :subtitle, presence: true

  def subtitle
    super || artist
  end
end
