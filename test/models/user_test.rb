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
end
