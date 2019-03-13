module StorefrontHelper
  def can_be_added_to_cart?(product)
    line_item = @line_items.find {|item| item.product_id == product.id}
    line_item.present? ? line_item.quantity < product.inventory : true
  end

  def cart_subtotal
    @line_items.sum(&:total_price)
  end

  def cart_quantity
    @line_items.sum(&:quantity)
  end
end
