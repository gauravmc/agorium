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

    assert_response :unprocessable_entity
    assert_match "Phone should be a 10-digit number", @response.body
  end

  test "xhr request to create action responds correctly when user cannot be created" do
    assert_no_difference('User.count') do
      post users_url, params: { user: { name: 'Dibs', phone: 'invalid' } }, xhr: true
    end

    assert_response :unprocessable_entity
    assert_equal "text/javascript", @response.content_type
    assert_match "Phone should be a 10-digit number", @response.body
  end

  test "should redirect to phone verification page once user is created" do
    stub_request(:post, /api.authy.com/).
      with(query: hash_including({ phone_number: '9800098000' })).
      to_return(status: 200)

    assert_difference('User.count') do
      post users_url, params: { user: { name: 'Dibs', phone: '9800098000' } }
    end

    assert_redirected_to verify_with_otp_path(User.last.id)
  end

  test "xhr request to create action responds correctly when user is created" do
    stub_request(:post, /api.authy.com/).
      with(query: hash_including({ phone_number: '9800098000' })).
      to_return(status: 200)

    assert_difference('User.count') do
      post users_url, params: { user: { name: 'Dibs', phone: '9800098000' } }, xhr: true
    end

    assert_response :success
    assert_equal "text/javascript", @response.content_type
    assert_match verify_with_otp_path(User.last.id), @response.body
  end
end
