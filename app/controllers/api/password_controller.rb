class Api::PasswordController < ApiController
  skip_before_action :authenticate!
  wrap_parameters false
  before_action :find_user_by_token, only: %i[show update]
  rescue_from ActiveSupport::MessageVerifier::InvalidSignature do
    render_error "Your password reset token is expired. Please try again.", status: :unauthorized
  end

  def create
    user = User.with_email(params[:email]).take!
    UserMailer.with(user: user).forgot_password.deliver_later
    render json: {
      message: "Check your email for a link to reset your password."
    }
  rescue ActiveRecord::RecordNotFound
    render_error "We can't find an account with that email address."
  end

  def show
    head :ok
  end

  def update
    if @user.update(password: params[:password])
      render @user
    else
      render_error record: @user
    end
  end

  private

  # Find user by password reset token
  def find_user_by_token
    @user ||= User.find_by_password_reset_token!(params[:token])
  end
end
