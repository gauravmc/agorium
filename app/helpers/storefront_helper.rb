module StorefrontHelper
  def can_be_added_to_cart?(product)
    line_item = current_cart.line_items.find {|item| item.product_id == product.id}
    line_item.present? ? line_item.quantity < product.inventory : true
  end
end
