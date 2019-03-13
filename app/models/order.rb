class Order < ApplicationRecord
  belongs_to :brand
  belongs_to :customer
  has_many :line_items, dependent: :destroy

  enum status: {
    pending: 'pending',
    confirmed: 'confirmed',
    shipped: 'shipped',
    cancelled: 'cancelled'
  }

  class ProductOutOfStockError < StandardError; end

  def self.generate(customer, cart)
    Order.transaction do
      customer.save
      order = Order.new(
        brand: cart.brand,
        customer: customer,
        total_price: cart.subtotal
      )
      order.confirmed!
      order.save!

      cart.transfer_items_to_order(order)
      order.update_products_inventory

      return order
    end
  end

  def update_products_inventory
    line_items.includes(:product).each do |line_item|
      product = line_item.product
      product.decrement(:inventory, line_item.quantity)

      if product.inventory < 0
        raise ProductOutOfStockError, "Product product_id=#{product.id} could not be added to Order order_id=#{id} because new inventory is becoming less than 0."
      else
        product.save(validate: false)
      end
    end
  end
end
