require "test_helper"

class AccessTokenTest < ActiveSupport::TestCase
  test "can encode and decode a token" do
    expected = AccessToken.new(user_id: 1)
    decoded = AccessToken.decode(expected.encode)

    assert_equal expected.attributes, decoded.attributes
    assert expected.jti
    assert expected.created_at
    assert expected.expire_at
  end

  test "decode invalid token" do
    assert_raises(JWT::DecodeError) { AccessToken.decode("nope") }
  end

  test "decode expired token" do
    token = build :access_token, expire_at: 1.second.ago
    assert_raises(JWT::ExpiredSignature) { AccessToken.decode(token.encode) }
  end
end
