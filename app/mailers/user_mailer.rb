class UserMailer < ApplicationMailer
  def forgot_password
    @user = params[:user]
    @user.generate_password_reset!
    mail to: @user.email, subject: "Reset your password"
  end
end
