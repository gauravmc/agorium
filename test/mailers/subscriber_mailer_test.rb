require 'test_helper'

class SubscriberMailerTest < ActionMailer::TestCase
  test "email_verification" do
    subscriber = Subscriber.create(email: "shawn@hotmail.com")
    mail = SubscriberMailer.email_verification(subscriber)
    assert_equal "Email ownership verification", mail.subject
    assert_equal [subscriber.email], mail.to
    assert_equal ["gaurav@agorium.io"], mail.from
    assert_match subscriber.verification_token,   mail.body.encoded
    assert_match CGI.escape(subscriber.email),    mail.body.encoded
  end
end
