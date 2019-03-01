require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:summer_butter)
  end

  test "name cannot be blank" do
    @product.name = ""
    refute @product.save
    assert_equal ["Name can't be blank"], @product.errors.full_messages
  end

  test "name cannot be longer than 255 characters" do
    bad_name = "A" * 257
    @product.name = bad_name
    refute @product.save
    assert_equal ["Name is too long (maximum is 255 characters)"], @product.errors.full_messages
  end

  test "description must be present" do
    @product.description = ""
    refute @product.save
    assert_equal ["Description can't be blank"], @product.errors.full_messages
  end

  test "price must be a decimal number" do
    @product.price = "invalid"
    refute @product.save
    assert_equal ["Price is not a number"], @product.errors.full_messages

    @product.price = "-1234"
    refute @product.save
    assert_equal ["Price must be greater than or equal to 0"], @product.errors.full_messages

    @product.price = 1234567890.42
    refute @product.save
    assert_equal ["Price must be less than or equal to 10000000.0"], @product.errors.full_messages

    @product.price = "1234"
    assert @product.save
    assert_equal 1234.00, @product.price.to_f

    @product.price = 12345.2365
    assert @product.save
    assert_equal 12345.24, @product.price.to_f
  end

  test "cost must be in decimal" do
    @product.cost = "invalid"
    refute @product.save
    assert_equal ["Cost is not a number"], @product.errors.full_messages

    @product.cost = "-1234"
    refute @product.save
    assert_equal ["Cost must be greater than or equal to 0"], @product.errors.full_messages

    @product.cost = 1234567890.42
    refute @product.save
    assert_equal ["Cost must be less than or equal to 10000000.0"], @product.errors.full_messages

    @product.cost = "1234"
    assert @product.save
    assert_equal 1234.00, @product.cost.to_f

    @product.cost = 12345.2365
    assert @product.save
    assert_equal 12345.24, @product.cost.to_f
  end

  test "handle must be set automatically as a paramterized form of product name" do
    @product.name = "Cool New Product"
    assert @product.save
    assert_equal "cool-new-product", @product.handle
  end

  test "settings handle explicitly does not work, as it get parameterized product name as value" do
    @product.handle = "some-new-handle"
    assert @product.save
    assert_equal "summer-butter", @product.handle
  end

  test "inventory must be an integer" do
    @product.inventory = "invalid"
    refute @product.save
    assert_equal ["Inventory is not a number"], @product.errors.full_messages

    @product.inventory = "-1234"
    refute @product.save
    assert_equal ["Inventory must be greater than or equal to 0"], @product.errors.full_messages

    @product.inventory = 1234567890.42
    assert @product.save
    assert_equal 1234567890, @product.inventory

    @product.inventory = "1234"
    assert @product.save
    assert_equal 1234, @product.inventory
  end

  test "product attributes have correct values after a valid creation" do
    product = Product.new(
      name: "Cool New Product",
      description: "Cool New Product is very cool.",
      price: 42.24,
      cost: 24.42,
      inventory: 42,
      owner: users(:shawn)
    )

    assert product.save
    assert_equal "Cool New Product", product.name
    assert_equal "Cool New Product is very cool.", product.description
    assert_equal "cool-new-product", product.handle
    assert_equal 42.24, product.price.to_f
    assert_equal 24.42, product.cost.to_f
    assert_equal 42, product.inventory
    assert product.published_at.present?
    assert_equal users(:shawn).id, product.owner.id
  end
end