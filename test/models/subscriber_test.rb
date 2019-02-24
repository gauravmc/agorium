require 'test_helper'

class SubscriberTest < ActiveSupport::TestCase
  test "email must be present" do
    sub = Subscriber.new(email: nil)
    refute sub.save
    assert_equal ["Email is invalid"], sub.errors.full_messages
  end

  test "email cannot be longer than 255 chars" do
    long_email = "someridiculouslylongemailaddress"*10 + "@gmail.com"
    sub = Subscriber.new(email: long_email)
    refute sub.save
    assert_equal ["Email is too long (maximum is 255 characters)"], sub.errors.full_messages
  end

  test "email must be uniq" do
    sub = Subscriber.new(email: "shawn@gmail.com")
    refute sub.save
    assert_equal ["Email has already been taken"], sub.errors.full_messages
  end

  test "email must be valid email address" do
    sub = Subscriber.new(email: "shawn@gmail,com")
    refute sub.save
    assert_equal ["Email is invalid"], sub.errors.full_messages

    sub = Subscriber.new(email: "shawn.gmail@com")
    refute sub.save
    assert_equal ["Email is invalid"], sub.errors.full_messages

    sub = Subscriber.new(email: "shawn.gmailcom")
    refute sub.save
    assert_equal ["Email is invalid"], sub.errors.full_messages
  end

  test "email is lowercased before saving" do
    sub = Subscriber.new(email: "SHAWN@hotmail.com")
    assert sub.save
    assert_equal "shawn@hotmail.com", sub.email
  end

  test "email_verified is false by default" do
    sub = Subscriber.new(email: "shawn@hotmail.com")
    assert sub.save
    assert_equal false, sub.email_verified
  end

  test "verification_token attr is set and verification_digest is added before creation" do
    sub = Subscriber.new(email: "shawn@hotmail.com")
    assert sub.save
    assert sub.verification_token.present?
    assert sub.verification_digest.present?
  end

  test "verification_token_valid? verifies given token with verification_digest" do
    sub = Subscriber.new(email: "shawn@hotmail.com")
    assert sub.save

    token = sub.verification_token
    assert sub.verification_token_valid?(token)
  end

  test "email_successfully_verified! updates email_verified and verified_at" do
    sub = Subscriber.create(email: "shawn@hotmail.com")
    refute sub.verified_at.present?

    sub.email_successfully_verified!
    assert sub.reload.email_verified?
    assert sub.verified_at
  end
end
