class User < ApplicationRecord
  has_many :access_tokens, dependent: :delete_all
  has_many :owned_setlists, class_name: "Setlist", dependent: :destroy
  has_many :library, class_name: "LibraryItem", dependent: :destroy do
    def add(item)
      find_or_create_by(item: item)
    end
  end
  has_many :artists, through: :library, source: :item, source_type: "Artist"
  has_many :albums, through: :library, source: :item, source_type: "Album"
  has_many :songsheets, through: :library, source: :item, source_type: "Songsheet"
  has_many :setlists, through: :library, source: :item, source_type: "Setlist"

  has_secure_password
  has_subscriptions

  validates :email,
    uniqueness: {case_sensitive: false},
    presence: true,
    format: {with: URI::MailTo::EMAIL_REGEXP}
  validates :password, password_strength: true, if: :password_digest_changed?

  scope :with_email, ->(email) { where("LOWER(email) = ?", email.to_s.downcase) }

  before_save :clear_password_reset_token, if: :password_digest_changed?
  after_create :create_default_setlists
  after_create { subscribe("news") }

  def self.authenticate!(email, password)
    with_email(email).take!.authenticate(password) || raise(ActiveRecord::RecordNotFound)
  end

  def self.find_for_password_reset!(token)
    find_by!(password_reset_token: token, password_reset_sent_at: 2.hours.ago..)
  end

  def self.app
    find_or_create_by!(email: "help@chordbook.app") do |user|
      user.name = "Chord Book"
      user.password = SecureRandom.alphanumeric
    end
  end

  def generate_password_reset!
    update!(
      password_reset_token: SecureRandom.alphanumeric,
      password_reset_sent_at: Time.now
    )
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

  def clear_password_reset_token
    self.password_reset_token = nil
    self.password_reset_sent_at = nil
  end
end
