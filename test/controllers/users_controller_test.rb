require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_user_url
    assert_response :success
  end

  test "should get new as signup url" do
    get signup_url
    assert_response :success
  end

  test "should render errors when user cannot be created" do
    assert_no_difference('User.count') do
      post users_url, params: { user: { name: 'Dibs', phone: 'invalid' } }
    end

    assert_match "Phone is not a number", @response.body
  end

  test "should redirect to phone verification page once user is created" do
    assert_difference('User.count') do
      post users_url, params: { user: { name: 'Dibs', phone: '9800098000' } }
    end

    assert_redirected_to user_verify_path(User.last.id)
  end

  test "verify renders otp entering page" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')

    get user_verify_url(new_user.id)
    assert_response :success
    assert_match "Please enter the 6-digit OTP", @response.body
  end

  test "should render errors when otp cannot be verified" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')
    put user_check_otp_url(new_user.id), params: { otp: 'invalid' }

    assert_match "OTP did not match, please try entering again", @response.body
  end

  test "should update user record and redirect to home once otp is good" do
    new_user = User.create!(name: 'Garr', phone: '9604884000')
    put user_check_otp_url(new_user.id), params: { otp: '420042' }

    assert new_user.reload.phone_verified?
    assert_redirected_to root_path
  end
end