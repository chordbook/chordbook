# Preview all emails at http://localhost:3000/rails/mailers/password_mailer
class UserMailerPreview < ActionMailer::Preview
  def welcome
    UserMailer.with(user: User.first).welcome
  end

  def forgot_password
    UserMailer.with(user: User.first).forgot_password
  end
end
