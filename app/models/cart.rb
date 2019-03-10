class Cart < ApplicationRecord
  belongs_to :brand
  has_many :line_items

  def add_product(product)
    return unless product.is_in_stock?

    if line_item = line_items.find_by(product: product)
      line_item.increment(:quantity)
    else
      line_items.build(product: product)
    end
  end

  def quantity
    line_items.sum(&:quantity)
  end

  def subtotal
    line_items.sum(&:total_price)
  end

  def transfer_items_to_order(order)
    line_items.update_all(cart_id: nil, order_id: order.id)
  end
end
