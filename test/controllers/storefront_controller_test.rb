require 'test_helper'

class StorefrontControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:maple_skin)
  end

  test "storefront path redirects with flash error if Brand cannot be found" do
    get storefront_path('invalid')

    assert_redirected_to root_path
    assert_equal "Brand named 'invalid' does not exist.", flash[:danger]
  end

  test "renders the storefront for a brand when it's found" do
    attach_product_fixtures_photos

    get storefront_path(@brand.handle)

    assert_response :success
    assert_match @brand.name, @response.body
    assert_match @brand.products.first.name, @response.body
  end
end
