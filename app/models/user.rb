class User < ApplicationRecord
  has_many :access_tokens, dependent: :delete_all
  has_many :owned_setlists, class_name: "Setlist", dependent: :destroy
  has_many :library, class_name: 'LibraryItem', dependent: :destroy do
    def add(item)
      find_or_create_by(item: item)
    end
  end
  has_many :artists, through: :library, source: :item, source_type: "Artist"
  has_many :albums, through: :library, source: :item, source_type: "Album"
  has_many :songsheets, through: :library, source: :item, source_type: "Songsheet"
  has_many :setlists, through: :library, source: :item, source_type: "Setlist"

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
