require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  setup do
    @product = products(:summer_butter)
    @brand = brands(:maple_skin)
    attach_product_fixtures_photos
  end

  teardown do
    purge_product_fixtures_photos
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

  test "handle must be unique for given brand" do
    product = new_product
    product.name = @brand.products.first.name

    refute product.save
    assert_equal ["Handle has already been taken"], product.errors.full_messages
  end

  test "different brands can have same product handles" do
    product = new_product
    product.name = brands(:cards_and_more).products.first.name

    assert product.save
    assert_equal 'wedding-card', product.handle
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

  test "product cannot be saved without at least one photo" do
    existing_product = products(:summer_butter)
    existing_product.photos.purge
    refute existing_product.save
    assert_equal ["Photos must be present. Add at least one photo"], @product.errors.full_messages

    product = new_product
    product.photos.detach
    refute product.save
    assert_equal ["Photos must be present. Add at least one photo"], @product.errors.full_messages
  end

  test "product photo must be of jpeg format" do
    product = products(:wedding_card)
    product.photos.attach(io: file_fixture('avatar.png').open, filename: 'avatar.png')
    refute product.save
    assert_equal ["Photos must be of type image/jpeg only"], product.errors.full_messages
  end

  test "is_in_stock? returns true or false based on inventory availability" do
    assert @product.is_in_stock?

    @product.update_column(:inventory, 0)

    refute @product.is_in_stock?
  end

  test "product attributes have correct values after a valid creation" do
    product = new_product

    assert product.save
    assert_equal "Cool New Product", product.name
    assert_equal "Cool New Product is very cool.", product.description
    assert_equal "cool-new-product", product.handle
    assert_equal 42.24, product.price.to_f
    assert_equal 24.42, product.cost.to_f
    assert_equal 42, product.inventory
    assert product.published_at.present?
    assert_equal @brand.id, product.owner.id
    assert product.photos.attached?
    assert_equal 'cool_product.jpeg', product.photos.first.filename.to_s
  end

  private

  def new_product
    Product.new(
      name: "Cool New Product",
      description: "Cool New Product is very cool.",
      price: 42.24,
      cost: 24.42,
      inventory: 42,
      photos: [Rack::Test::UploadedFile.new(file_fixture('cool_product.jpeg'))],
      owner: @brand
    )
  end
end
