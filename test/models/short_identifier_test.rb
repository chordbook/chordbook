require "test_helper"

class SearchTest < ActiveSupport::TestCase
  test "short_id" do
    token = create :access_token
    assert_match /\Ax[0-9a-z]{19,22}\z/i, token.uid
    assert_equal token.uid, token.to_param
    assert_equal token, ShortIdentifier.locate(token.uid)
    assert_equal token, AccessToken.find_by_uid(token.uid)
  end
end
