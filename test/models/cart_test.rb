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
end