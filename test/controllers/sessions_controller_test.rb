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
end
