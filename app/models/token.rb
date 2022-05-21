class Token < ApplicationRecord
  # Signing secret derived from secret_key_base
  class_attribute :secret, default: Rails.application.key_generator.generate_key('token')

  # Default expiry for access tokens
  class_attribute :expiry, default: 1.day

  # The algorithm to use to sign the token
  # https://github.com/jwt/ruby-jwt#algorithms-and-usage
  class_attribute :algorithm, default: 'HS256'

  belongs_to :user

  # Alias JWT names to more explicit model names
  alias_attribute :iat, :created_at
  alias_attribute :exp, :expires_at

  after_initialize :set_defaults

  module Error; end
  # Tag JWT errors
  JWT::DecodeError.extend(Error)

  def self.decode(string, verify: true)
    new JWT.decode(string, secret, verify, verify_iat: true)[0]
  end

  def encode
    JWT.encode(payload, secret, algorithm)
  end

  def header
    "Bearer #{encode}"
  end

  def payload
    {
      user_id: user_id,
      jti: jti,
      iat: created_at.to_i,
      exp: expires_at.to_i
    }
  end

  def set_defaults
    self.jti ||= SecureRandom.hex
    self.created_at ||= Time.now.floor # JWT doesn't store milliseconds
    self.expires_at ||= created_at + expiry
  end
end
