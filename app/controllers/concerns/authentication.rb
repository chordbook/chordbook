module Authentication
  extend ActiveSupport::Concern

  included do
    rescue_from AccessToken::Invalid, JWT::DecodeError, with: :access_denied

    # Make sure we have a valid token before running any action
    before_action :current_token
  end

  private

  # Render a 401 response for the given exception
  def access_denied(exception)
    render_error exception: exception, status: :unauthorized
  end

  # Retuns `AccessToken` for the JWT povided in the Authorization header.
  #
  # Raises JWT::DecodeError if Authorization header does not contain valid JWT
  # Raises ActiveRecord::RecordNotFound if token is invalidated
  def current_token!
    @current_token ||= AccessToken.validate(encoded_token)
  end
  alias_method :authenticate!, :current_token!

  # Same as `#current_token!`, but returns nil if user is not authenticated
  # It will still raise an error if the token is invalid
  def current_token
    current_token! if encoded_token
  end

  # Return `User` identified by current token. Raises same errors as `#current_token!`
  def current_user!
    current_token!.user
  end

  # Return `User` or nil if user is not authenticated
  def current_user
    current_token&.user
  end

  # Issue a new `AccessToken` for the given user
  def issue_token(user)
    user.access_tokens.create!(auth_audit_attrs).tap do |token|
      set_token_headers token
    end
  end

  # Returns a new `AccessToken`, refreshing the token identified by the `refresh_token` parameter
  def refresh_token!(refresh_token = params[:refresh_token])
    AccessToken.refresh(refresh_token, auth_audit_attrs).tap do |token|
      set_token_headers token
    end
  end

  # Internal: Set token in response headers
  def set_token_headers(token)
    response.headers.update token.response_headers
  end

  # Internal: Attributes to include when issuing and refreshing tokens
  def auth_audit_attrs
    {
      remote_ip: request.remote_ip,
      user_agent: request.user_agent
    }
  end

  # Internal: the token provided in the Authorization header
  def encoded_token
    request.headers["Authorization"]&.split("Bearer ")&.last
  end
end
