require 'test_helper'

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:maple_skin)
    @product = products(:charcoal_soap)
  end

  test "create does not respond to HTML request" do
    assert_raise(ActionController::UnknownFormat) do
      post line_items_url, params: { line_item: new_line_item_params }
    end
  end

  test "create renders js.erb when line item is created successfully" do
    assert_difference('@product.line_items.count') do
      post line_items_url, params: { line_item: new_line_item_params }, xhr: true
    end

    assert_response :success
    assert_equal "text/javascript", @response.content_type
    line_item = LineItem.last
    assert_equal new_line_item_params[:product_id], line_item.product.id
    assert_match "querySelector('#cartLink')", @response.body
  end

  private

  def new_line_item_params
    {
      brand_id: @brand.id,
      product_id: @product.id
    }
  end
end
