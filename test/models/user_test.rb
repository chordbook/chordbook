require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "validates email" do
    refute build(:user, email: nil).valid?
    refute build(:user, email: "").valid?
    refute build(:user, email: "nope").valid?

    # Technically valid
    assert build(:user, email: "a@b").valid?
    assert build(:user, email: "test@example.com").valid?
  end

  test "validates strong password" do
    refute build(:user, password: "password").valid?

    # Update
    user = create(:user)
    refute user.update(password: "nope")
    refute user.valid?

    assert build(:user, password: "r@nd0m4ccEsSM3mºr!e$").valid?
  end

  test "validates presence of password" do
    user = create(:user)
    refute user.update(password: nil)
  end

  test "creates default setlists" do
    assert_difference -> { Setlist.count }, User::DEFAULT_SETLISTS.size do
      user = create(:user)

      assert_equal User::DEFAULT_SETLISTS.size, user.setlists.count
      assert_equal user.setlists.count, user.owned_setlists.count
    end
  end

  test "find_by_password_reset_token!" do
    user = create(:user)

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      User.find_by_password_reset_token!(nil)
    end

    assert_equal user, User.find_by_password_reset_token!(user.password_reset_token)

    # Expired
    token = user.password_reset_token
    travel 16.minutes

    assert_raises ActiveSupport::MessageVerifier::InvalidSignature do
      User.find_by_password_reset_token!(token)
    end
  end
end
