require "test_helper"

class AccessTokenTest < ActiveSupport::TestCase
  test "can encode and decode a token" do
    expected = create :access_token
    decoded = AccessToken.validate(expected.encode)

    assert_equal expected, decoded
    assert expected.jti
    assert expected.created_at
    assert expected.expire_at
  end

  test "decode blocked token" do
    token = create :access_token, invalidated_at: Time.now

    assert_raises(ActiveRecord::RecordNotFound) { AccessToken.validate(token.encode) }
  end

  test "decode invalid token" do
    assert_raises(JWT::DecodeError) { AccessToken.validate("nope") }
  end

  test "decode expired token" do
    token = build :access_token, expire_at: 1.second.ago
    assert_raises(JWT::ExpiredSignature) { AccessToken.validate(token.encode) }
  end

  test "refresh returns new token for user" do
    token = create :access_token

    new_token = AccessToken.refresh(token.refresh_token)

    assert_not_equal new_token, token
    assert token.reload.invalidated_at?
    assert_equal token.user_id, new_token.user_id
  end

  test "refresh does not work with blocked token" do
    token = create :access_token, invalidated_at: Time.now

    assert_raises ActiveRecord::RecordNotFound do
      AccessToken.refresh(token.refresh_token)
    end
  end

  test "refresh with expired token" do
    valid = create :access_token, expire_at: AccessToken.refresh_token_expiry.ago + 5
    expired = create :access_token, expire_at: AccessToken.refresh_token_expiry.ago - 5

    # Nothing raised
    AccessToken.refresh(valid.refresh_token)

    assert_raises ActiveRecord::RecordNotFound do
      AccessToken.refresh(expired.refresh_token)
    end
  end

  test "short_id" do
    token = create :access_token
    assert_equal "x#{token.short_id}", token.uid
    assert_equal token.uid, token.to_param
    assert_equal token, ShortIdentifier.locate(token.uid)
    assert_equal token, AccessToken.find_by_uid(token.uid)
  end
end
