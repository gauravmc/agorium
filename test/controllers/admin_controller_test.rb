require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "user gets redirected to login page if not logged in" do
    get admin_url
    assert_redirected_to login_path
  end

  test "get admin index works okay once user is logged in" do
    log_in_as users(:dibs)
    get admin_url
    assert_response :success
  end
end
