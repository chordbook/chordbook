module Authentication
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::DecodeError, with: :access_denied
  end

  # Delegeate #current_user
  delegate :user, to: :current_token, prefix: :current

  def encoded_token
    request.headers["Authorization"]&.split('Bearer ')&.last
  end

  def current_token
    @token ||= Token.decode(encoded_token)
  end

  def access_denied(exception)
    render json: { error: exception.message }, status: :unauthorized
  end

  def authenticate!
    current_user
  end
end
