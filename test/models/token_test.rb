require "test_helper"

class TokenTest < ActiveSupport::TestCase
  test "can encode and decode a token" do
    expected = Token.new(user_id: 1)
    decoded = Token.decode(expected.encode)

    assert_equal expected.attributes, decoded.attributes
    assert expected.jti
    assert expected.created_at
    assert expected.expires_at
  end

  test "decode invalid token" do
    assert_raises(JWT::DecodeError) { Token.decode("nope") }
  end

  test "decode expired token" do
    token = build :token, expires_at: 1.second.ago
    assert_raises(JWT::ExpiredSignature) { Token.decode(token.encode) }
  end
end
