require "test_helper"

class ViewableTest < ActiveSupport::TestCase
  test "viewed scope only includes distinct viewed records" do
    viewed = create :songsheet
    create :songsheet # unviewed

    create :event, :view, record: viewed

    assert_equal [viewed], Songsheet.viewed
  end

  test "viewed_by scope only includes records viewed by user" do
    user = create :user
    viewed = create :songsheet
    unviewed = create :songsheet

    # Play twice
    create :event, :view, record: viewed, user: user
    create :event, :view, record: viewed, user: user

    # other user, other song
    create :event, :view, record: unviewed, user: create(:user)

    assert_equal [viewed], Songsheet.viewed_by(user)
  end
end
