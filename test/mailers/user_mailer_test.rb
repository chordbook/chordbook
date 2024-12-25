require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome" do
    user = create(:user)
    email = UserMailer.with(user: user).welcome

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.email], email.to
  end

  test "forgot_password" do
    user = create(:user)
    email = UserMailer.with(user: user).forgot_password

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ["help@chordbook.app"], email.from
    assert_equal [user.email], email.to
    assert_equal "Reset your password", email.subject
    assert_match email.body, %r{/password/reset\?token=.+}
  end
end
