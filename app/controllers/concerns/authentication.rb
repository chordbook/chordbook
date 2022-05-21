module Authentication
  extend ActiveSupport::Concern

  included do
    rescue_from JWT::DecodeError, with: :access_denied
  end

  private

  # Delegeate #current_user
  delegate :user, to: :current_token, prefix: :current

  def encoded_token
    request.headers["Authorization"]&.split("Bearer ")&.last
  end

  def current_token
    @token ||= AccessToken.decode(encoded_token)
  end

  def issue_token(user)
    token = user.access_tokens.create!
    set_token_headers(token)
    token
  end

  # Set token details in response headers
  def set_token_headers(token)
    response.headers.update token.response_headers
  end

  def access_denied(exception)
    render json: {error: exception.message}, status: :unauthorized
  end

  def authenticate!
    current_user
  end
end
