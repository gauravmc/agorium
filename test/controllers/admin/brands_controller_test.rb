require 'test_helper'

class Admin
  class BrandsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @user = User.create!(name: 'Garr', phone: '9604884000')
      log_in_as(@user)
    end

    test "new renders new product page" do
      get new_admin_brand_url

      assert_response :success
      assert_match 'Add few details about your brand', @response.body
    end

    test "redirects to admin root if brand already exists" do
      log_in_as(users(:dibs))
      get new_admin_brand_url

      assert_redirected_to admin_root_url
    end

    test "create renders form with errors when product is invalid" do
      params = new_brand_params
      params[:city] = "42"

      assert_no_difference('Brand.count') do
        post admin_brand_url, params: { brand: params }
      end

      assert_response :unprocessable_entity
      assert_match "City name should only contain letters", @response.body

      assert_no_difference('Brand.count') do
        post admin_brand_url, params: { brand: params }, xhr: true
      end

      assert_response :unprocessable_entity
      assert_equal "text/javascript", @response.content_type
      assert_match "City name should only contain letters", @response.body
    end

    test "create redirects with success message when product is valid" do
      assert_difference('Brand.count') do
        post admin_brand_url, params: { brand: new_brand_params }
      end

      assert_equal "Your account is fully set up now. Welcome! You can start by adding some products.", flash[:success]
      assert_redirected_to admin_root_url
      assert_equal new_brand_params[:name], @user.brand.name

      Brand.last.destroy
      assert_difference('Brand.count') do
        post admin_brand_url, params: { brand: new_brand_params }, xhr: true
      end

      assert_response :success
      assert_equal "text/javascript", @response.content_type
      assert_equal "Your account is fully set up now. Welcome! You can start by adding some products.", flash[:success]
      assert_match admin_root_url, @response.body
      assert_equal new_brand_params[:name], @user.brand.name
    end

    test "edit renders brand edit form" do
      log_in_as(users(:dibs))

      get edit_admin_brand_url

      assert_response :success
      assert_match 'Maple Skin', @response.body
      assert_match 'Save settings', @response.body
    end

    test "update renders errors when params are invalid" do
      log_in_as(users(:dibs))

      put admin_brand_url, params: { brand: { city: '' } }, xhr: true

      assert_response :unprocessable_entity
      assert_equal "text/javascript", @response.content_type
      assert_match "City name should only contain letters", @response.body
    end

    test "update updates brand and redirects with success when params are valid" do
      user = users(:dibs)
      log_in_as(user)

      put admin_brand_url, params: { brand: { name: 'Supple Skincare' } }, xhr: true

      assert_response :success
      assert_equal "text/javascript", @response.content_type
      assert_equal "Your brand settings were successfully updated.", flash[:success]
      assert_match admin_root_url, @response.body
      assert_equal 'Supple Skincare', user.brand.name
    end

    private

    def new_brand_params
      {
        name: 'New Brand',
        story: "Our brand's story is awesome.",
        city: 'Mumbai',
        state: 'Maharashtra'
      }
    end
  end
end
