require 'test_helper'

class Admin
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = users(:shawn)
      @brand = @user.brand
      log_in_as(@user)
    end

    test "index renders list of products" do
      attach_product_fixtures_photos

      get admin_products_url

      assert_response :success

      products = @brand.products
      assert_match 'Your Products', @response.body
      assert_match products.first.name, @response.body
      assert_match products.last.name, @response.body
    end

    test "new renders new product page" do
      get new_admin_product_url

      assert_response :success
      assert_match 'Add a new Product', @response.body
    end

    test "create renders form with errors when product is invalid" do
      params = new_product_params
      params[:price] = ""

      assert_no_difference('@brand.products.count') do
        post admin_products_url, params: { product: params }
      end

      assert_response :unprocessable_entity
      assert_match "Selling price is not a number", @response.body

      assert_no_difference('@brand.products.count') do
        post admin_products_url, params: { product: params }, xhr: true
      end

      assert_response :unprocessable_entity
      assert_equal "text/javascript", @response.content_type
      assert_match "Selling price is not a number", @response.body
    end

    test "create redirects with success message when product is valid" do
      assert_difference('@brand.products.count') do
        post admin_products_url, params: { product: new_product_params }
      end

      assert_equal "#{new_product_params[:name]} was successfully added to your products!", flash[:success]
      assert_redirected_to admin_products_url
      assert_equal new_product_params[:name], @brand.products.last.name

      Product.last.destroy
      assert_difference('@brand.products.count') do
        post admin_products_url, params: { product: new_product_params }, xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
      assert_equal "#{new_product_params[:name]} was successfully added to your products!", flash[:success]
      assert_match admin_products_url, @response.body
      assert_equal new_product_params[:name], @brand.products.last.name
    end

    test "destroy removes the product from the database" do
      Cart.destroy_all
      product = @brand.products.first

      assert_difference('@brand.products.count', -1) do
        delete admin_product_url(product)
      end

      assert_equal "#{product.name} was deleted from your products.", flash[:success]
      assert_redirected_to admin_products_url
    end

    private

    def new_product_params
      {
        name: "Cool New Product",
        description: "Cool New Product is very cool.",
        price: 42.24,
        cost: 24.42,
        inventory: 42,
        photos: [fixture_file_upload(file_fixture('cool_product.jpeg'))]
      }
    end
  end
end
