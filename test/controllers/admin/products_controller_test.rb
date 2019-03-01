require 'test_helper'

class Admin
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      log_in_as(users(:shawn))
    end

    test "new renders new product page" do
      get new_admin_product_url

      assert_response :success
      assert_match 'Add a new Product', @response.body
    end
  end
end
