require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "renders new" do
    get login_url
    assert_response :success
    assert_match 'Log in to Agorium', @response.body
  end

  test "create returns error if mobile number is invalid" do
    post login_url, params: { session: { phone: 'invalid' } }

    assert_response :unprocessable_entity
    assert_match "Phone should be a 10-digit number", @response.body

    post login_url, params: { session: { phone: 'invalid' } }, xhr: true

    assert_response :unprocessable_entity
    assert_equal "text/javascript", @response.content_type
    assert_match "Phone should be a 10-digit number", @response.body
  end

  test "create returns error if user could not be found" do
    post login_url, params: { session: { phone: '1234567890' } }

    assert_response :unprocessable_entity
    assert_match "We couldn’t find an account with that number", @response.body

    post login_url, params: { session: { phone: '1234567890' } }, xhr: true

    assert_response :unprocessable_entity
    assert_equal "text/javascript", @response.content_type
    assert_match "We couldn’t find an account with that number", @response.body
  end

  test "verify renders otp entering page" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')

    get verify_with_otp_url(new_user.id)
    assert_response :success
    assert_match "Enter the OTP number that we messaged you", @response.body
  end

  test "should render errors when otp cannot be verified" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')
    post check_otp_url(new_user.id), params: { otp: 'invalid' }

    assert_match "We couldn’t match that one. Want to try again?", @response.body
  end

  test "xhr request should render errors when otp cannot be verified" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')
    post check_otp_url(new_user.id), params: { otp: 'invalid' }, xhr: true

    assert_response :unprocessable_entity
    assert_equal "text/javascript", @response.content_type
    assert_match "We couldn’t match that one. Want to try again?", @response.body
  end

  test "should update user phone_verified and redirect to home once otp is good" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')
    post check_otp_url(new_user.id), params: { otp: '420042' }

    assert new_user.reload.phone_verified?
    assert_redirected_to root_path
  end

  test "xhr request should update user phone_verified once otp is good" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')
    post check_otp_url(new_user.id), params: { otp: '420042' }, xhr: true

    assert new_user.reload.phone_verified?
    assert_equal "text/javascript", @response.content_type
    assert_match "Turbolinks.visit", @response.body
    assert_match root_path, @response.body
  end

  test "does not touch user record if phone was already verified" do
    user = users(:dibs)
    updated_at = user.updated_at

    post check_otp_url(user.id), params: { otp: '420042' }, xhr: true

    assert_equal updated_at, user.reload.updated_at
    assert_equal "text/javascript", @response.content_type
    assert_match "Turbolinks.visit", @response.body
    assert_match root_path, @response.body
  end
end
