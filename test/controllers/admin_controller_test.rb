require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "user gets redirected to login page if not logged in" do
    get admin_root_url
    assert_redirected_to login_path
  end

  test "get admin index works okay once user is logged in" do
    log_in_as users(:dibs)
    get admin_root_url
    assert_redirected_to admin_products_path
  end

  test "redirects a new user to brands#new page to finish account setup" do
    user = User.create!(name: 'Garr', phone: '9604884000')
    log_in_as user
    get admin_root_url
    assert_redirected_to new_admin_brand_path
  end
end
