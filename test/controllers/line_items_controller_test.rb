require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:maple_skin)
    @product = products(:charcoal_soap)
  end

  test "create does not respond to HTML request" do
    assert_raise(ActionController::UnknownFormat) do
      post line_items_url(@brand.handle), params: { line_item: { product_id: @product.id } }
    end
  end

  test "create renders js.erb when line item is created successfully" do
    assert_difference('@product.line_items.count') do
      post line_items_url(@brand.handle), params: { line_item: { product_id: @product.id } }, xhr: true
    end

    assert_response :success
    assert_equal "text/javascript", @response.content_type
    line_item = LineItem.last
    assert_equal @product.id, line_item.product.id
    assert_match "querySelector('#cartLink')", @response.body
  end

  test "destroy removes the line item from the database" do
    cart = current_session_cart(@brand)
    line_item = cart.line_items.create!(product: @product, cart: cart)

    assert_difference('@product.line_items.count', -1) do
      delete line_item_url(@brand.handle, line_item), xhr: true
    end

    assert_response :success
    assert_equal "text/javascript", @response.content_type
    assert_match "document.querySelector('#lineItemRow#{line_item.id}').remove()", @response.body
    assert_match "querySelector('#cartLink')", @response.body
    assert_match "querySelector('#cartSubtotal')", @response.body
  end

  private

  def current_session_cart(brand)
    attach_product_fixtures_photos
    get storefront_path(brand.handle)
    Cart.find(session["cart_id_#{brand.id}".to_sym])
  end
end
