class User < ApplicationRecord
  has_secure_password
  has_many :tokens, dependent: :delete_all
end
