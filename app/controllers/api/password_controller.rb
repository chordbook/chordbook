class Api::PasswordController < ApiController
  skip_before_action :authenticate!
  rescue_from ActiveRecord::RecordNotFound, with: :access_denied

  def create
    user = User.with_email(params[:email]).take
    if user
      UserMailer.with(user: user).forgot_password.deliver_later
      render json: {alert: "Check your email for a link to reset your password"}
    else
      head :not_found
    end
  end

  def show
    head :ok if current_user
  end

  def update
    if current_user.update(password: params[:password])
      render current_user
    else
      render_error record: current_user
    end
  end

  private

  # Find user by password reset token
  def current_user
    @current_user ||= User.find_for_password_reset!(params[:token])
  end
end
