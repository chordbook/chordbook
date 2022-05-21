class User < ApplicationRecord
  has_many :tokens, dependent: :delete_all

  has_secure_password

  validates :email, uniqueness: {case_sensitive: false}
end
