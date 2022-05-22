class User < ApplicationRecord
  has_many :access_tokens, dependent: :delete_all

  has_secure_password

  validates :email,
    uniqueness: {case_sensitive: false},
    presence: true,
    format: {with: URI::MailTo::EMAIL_REGEXP}

  scope :with_email, ->(email) { where("LOWER(email) = ?", email.to_s.downcase) }

  def self.authenticate!(email, password)
    with_email(email).first!.authenticate(password) || raise(ActiveRecord::RecordNotFound)
  end
end
