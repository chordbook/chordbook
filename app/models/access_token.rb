class AccessToken < ApplicationRecord
  # Signing secret derived from secret_key_base
  class_attribute :secret, default: Rails.application.key_generator.generate_key("access_token")

  # Default expiry for access tokens
  class_attribute :expiry, default: 1.hour

  # The algorithm to use to sign the token
  # https://github.com/jwt/ruby-jwt#algorithms-and-usage
  class_attribute :algorithm, default: "HS256"

  # Digest to use for stored refresh tokens
  class_attribute :digest, default: Digest::SHA256

  belongs_to :user

  scope :valid, -> { where(invalidated_at: nil).joins(:user) }
  scope :with_refresh_token, ->(token) {
    where refresh_token_digest: digest.hexdigest(token)
  }

  # Alias JWT names to more explicit model names
  alias_attribute :iat, :created_at
  alias_attribute :exp, :expire_at

  # Transient attribute for generated refresh token
  attr_accessor :refresh_token

  after_initialize :set_defaults
  before_save :digest_refresh_token

  def self.validate(token)
    valid.find_by! decode(token).slice(:jti)
  end

  def self.decode(token, verify = true)
    JWT.decode(token, secret, verify, verify_iat: true, algorithm: algorithm)[0]
  end

  def self.refresh(refresh_token, attrs = {})
    valid.with_refresh_token(refresh_token).take!.refresh!(attrs)
  end

  def encode
    JWT.encode(payload, secret, algorithm)
  end

  def payload
    {
      user_id: user_id,
      jti: jti,
      iat: created_at.to_i,
      exp: expire_at.to_i
    }
  end

  def refresh!(attrs)
    transaction do
      invalidate!
      AccessToken.create! attrs.merge(user: user)
    end
  end

  def request_headers
    {
      "Authorization" => "Bearer #{encode}"
    }
  end

  def response_headers
    {
      "Access-Token" => encode,
      "Expire-At" => expire_at.to_i,
      "Refresh-Token" => refresh_token
    }
  end

  def invalidate!
    update! invalidated_at: Time.now
  end

  private

  def set_defaults
    self.jti ||= SecureRandom.hex
    self.created_at ||= Time.now.floor # JWT doesn't store milliseconds
    self.expire_at ||= created_at + expiry
    self.refresh_token = SecureRandom.hex
  end

  def digest_refresh_token
    self.refresh_token_digest = digest.hexdigest(refresh_token)
  end
end
