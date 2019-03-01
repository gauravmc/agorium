require 'test_helper'

class Admin
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:shawn)
      log_in_as(@user)
    end

    test "new renders new product page" do
      get new_admin_product_url

      assert_response :success
      assert_match 'Add a new Product', @response.body
    end

    test "create renders form with errors when product is invalid" do
      params = new_product_params
      params[:price] = ""

      assert_no_difference('Product.count') do
        post admin_products_url, params: { product: params }
      end

      assert_response :unprocessable_entity
      assert_match "Selling price is not a number", @response.body

      assert_no_difference('Product.count') do
        post admin_products_url, params: { product: params }, xhr: true
      end

      assert_response :unprocessable_entity
      assert_equal "text/javascript", @response.content_type
      assert_match "Selling price is not a number", @response.body
    end

    test "create redirects with success message when product is valid" do
      assert_difference('Product.count') do
        post admin_products_url, params: { product: new_product_params }
      end

      assert_equal "#{new_product_params[:name]} was successfully added to your products!", flash[:success]
      assert_redirected_to new_admin_product_url
      assert_equal new_product_params[:name], @user.products.last.name

      assert_difference('Product.count') do
        post admin_products_url, params: { product: new_product_params }, xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
      assert_equal "#{new_product_params[:name]} was successfully added to your products!", flash[:success]
      assert_match new_admin_product_url, @response.body
      assert_equal new_product_params[:name], @user.products.last.name
    end

    private

    def new_product_params
      {
        name: "Cool New Product",
        description: "Cool New Product is very cool.",
        price: 42.24,
        cost: 24.42,
        inventory: 42
      }
    end
  end
end
