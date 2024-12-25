class UserMailer < ApplicationMailer
  def welcome
    @user = params[:user]
    mail to: @user.email, subject: "Thanks for using Chord Book", from: NEWS_FROM
  end

  def forgot_password
    @user = params[:user]
    mail to: @user.email, subject: "Reset your password", from: SUPPORT_FROM
  end
end
