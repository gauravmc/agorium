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

      return order
    end
  end
end
