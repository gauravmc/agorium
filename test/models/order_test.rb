require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  setup do
    @order = orders(:one)
  end

  test "order status can be of 4 said types only" do
    assert_raise(ArgumentError) do
      Order.create(
        brand: brands(:maple_skin),
        customer: customers(:vin),
        total_price: 42.42,
        status: 'invalid'
      )
    end

    @order.cancelled!
    assert_equal 'cancelled', @order.reload.status
    assert @order.cancelled?

    @order.status = 'shipped'
    @order.save!
    assert @order.reload.shipped?
  end

  test ".generate does not create order is customer is invalid" do
    customer = Customer.new(name: '', phone: '8767876534')

    assert_raise(ActiveRecord::NotNullViolation) do
      Order.generate(customer, carts(:maple_cart))
    end
  end

  test ".generate runs a transaction that saves given customer and creates order" do
    customer = Customer.new(name: 'Random dude', phone: '8767876534')

    assert_difference('Customer.count') do
      assert_difference('Order.count') do
        Order.generate(customer, carts(:maple_cart))
      end
    end
  end

  test ".generate cart line items get transferred to the order" do
    customer = Customer.new(name: 'Random dude', phone: '8767876534')
    cart = carts(:maple_cart)
    line_item_ids = cart.line_items.map(&:id)

    order = Order.generate(customer, carts(:maple_cart))

    assert_equal line_item_ids.size, order.line_items.count
    line_items = LineItem.where(id: line_item_ids)
    assert_equal [nil, nil], line_items.map(&:cart)
    assert_equal [order, order], line_items.map(&:order)
  end
end
