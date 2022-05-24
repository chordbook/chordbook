require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "validates email" do
    assert !build(:user, email: nil).valid?
    assert !build(:user, email: "").valid?
    assert !build(:user, email: "nope").valid?

    # Technically valid
    assert build(:user, email: "a@b").valid?
    assert build(:user, email: "test@example.com").valid?
  end

  test "validates strong password" do
    assert !build(:user, password: "password").valid?
  end

  test "creates default setlists" do
    assert_difference -> { Setlist.count }, User::DEFAULT_SETLISTS.size do
      user = create(:user)

      assert_equal User::DEFAULT_SETLISTS.size, user.setlists.count
      assert_equal user.setlists.count, user.owned_setlists.count
    end
  end
end
