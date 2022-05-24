class User < ApplicationRecord
  has_many :access_tokens, dependent: :delete_all
  has_many :owned_setlists, class_name: "Setlist", dependent: :destroy
  has_many :library_items, dependent: :destroy
  has_many :artists, through: :library_items, source: :item, source_type: "Artist"
  has_many :albums, through: :library_items, source: :item, source_type: "Album"
  has_many :songsheets, through: :library_items, source: :item, source_type: "Songsheet"
  has_many :setlists, through: :library_items, source: :item, source_type: "Setlist"

  has_secure_password

  validates :email,
    uniqueness: {case_sensitive: false},
    presence: true,
    format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, password_strength: true, on: :create

  scope :with_email, ->(email) { where("LOWER(email) = ?", email.to_s.downcase) }

  after_create :create_default_setlists

  def self.authenticate!(email, password)
    with_email(email).first!.authenticate(password) || raise(ActiveRecord::RecordNotFound)
  end

  def save_to_library(model)
    library_items.create! item: model
  end

  private

  DEFAULT_SETLISTS = [
    {title: "Learning", description: "Songs I am learning"},
    {title: "Want to Learn", description: "Songs I want to learn"},
    {title: "Standards", description: "Songs I know"}
  ]

  def create_default_setlists
    DEFAULT_SETLISTS.each { |attrs| owned_setlists.create(attrs) }
  end
end
