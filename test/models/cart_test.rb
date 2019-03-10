require 'test_helper'

class CartTest < ActiveSupport::TestCase
  setup do
    @cart = carts(:maple_cart)
  end

  test "quantity returns sum of all line_items' quantities" do
    assert_equal 4, @cart.quantity
    assert_equal 42, carts(:cards_cart).quantity
  end

  test "add_product increments quantity in existing line_item if it exists" do
    existing_line_item = line_items(:summer_butter_line_item)

    line_item = @cart.add_product(products(:summer_butter))

    assert_equal line_item.id, existing_line_item.id
    assert_not_equal line_item.quantity, existing_line_item.quantity
    assert_equal 4, line_item.quantity
  end

  test "add_product builds a new line_item with quantity 1 if it does not exist" do
    line_item = @cart.add_product(products(:charcoal_soap))

    refute line_item.persisted?
    assert_equal 1, line_item.quantity
  end

  test "add_product cannot build line item or increment existing one if product out of stock" do
    product = products(:charcoal_soap)
    product.update_column(:inventory, 0)

    refute @cart.add_product(product)

    product = products(:summer_butter)
    product.update_column(:inventory, 0)

    refute @cart.add_product(product)
  end

  test "transfer_items_to_order sets cart_id to nil and order_id to given order" do
    order = Order.first
    line_item_ids = @cart.line_items.map(&:id)

    @cart.transfer_items_to_order(order)

    line_items = LineItem.where(id: line_item_ids)
    assert_equal [nil, nil], line_items.map(&:cart)
    assert_equal [order, order], line_items.map(&:order)
  end
end
