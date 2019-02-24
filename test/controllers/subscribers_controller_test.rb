require 'test_helper'

class SubscribersControllerTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "create renders with errors if email is invalid" do
    post subscribers_url, params: { subscriber: { email: "invalid" } }, xhr: true
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_response :unprocessable_entity
    assert_equal "text/javascript", @response.content_type
    assert_match "Email is invalid", @response.body
  end

  test "create renders with errors if email is already taken" do
    post subscribers_url, params: { subscriber: { email: subscribers(:shawn).email } }, xhr: true
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_response :unprocessable_entity
    assert_equal "text/javascript", @response.content_type
    assert_match "Email has already been taken", @response.body
  end

  test "create renders success message and send email if subscriber is valid" do
    post subscribers_url, params: { subscriber: { email: "chotu@hotmail.com" } }, xhr: true
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_response :success
    assert_equal "text/javascript", @response.content_type
    assert_match "<p class='subtitle is-4 has-text-info'>Thank you for subscribing!</p>", @response.body
  end

  test "verification redirects with error if Subscriber could not be verified" do
    get subscriber_verification_url('token'), params: { email: subscribers(:shawn).email }

    assert_equal 'Verification link did not work. You might have already verified your email.', flash[:danger]
    assert_redirected_to root_path
  end

  test "verification redirects with success if Subscriber was verified" do
    subscriber = Subscriber.create(email: 'shawn@hotmail.com')
    get subscriber_verification_url(subscriber.verification_token), params: { email: subscriber.email }

    assert_equal 'Thank you for verifying your email address!', flash[:success]
    assert subscriber.reload.email_verified?
    assert_redirected_to root_path
  end
end
