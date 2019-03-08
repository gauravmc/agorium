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
end
