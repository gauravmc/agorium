require 'test_helper'

class BrandTest < ActiveSupport::TestCase
  setup do
    @brand = brands(:maple_skin)
  end

  test "name cannot be blank" do
    @brand.name = ""
    refute @brand.save
    assert_equal ["Name can't be blank"], @brand.errors.full_messages
  end

  test "name cannot be longer than 255 characters" do
    bad_name = "A" * 257
    @brand.name = bad_name
    refute @brand.save
    assert_equal ["Name is too long (maximum is 255 characters)"], @brand.errors.full_messages
  end

  test "handle must be set automatically as a paramterized form of product name" do
    @brand.name = "Harley Davidson"
    assert @brand.save
    assert_equal "harley-davidson", @brand.reload.handle
  end

  test "settings handle explicitly does not work, as it get parameterized product name as value" do
    @brand.handle = "some-new-handle"
    assert @brand.save
    assert_equal "maple-skin", @brand.reload.handle
  end

  test "handle only gets if in it if basic parameterized one is taken" do
    user = users(:dibs)
    destroy_brand(user.brand)

    brand = user.build_brand(new_brand_params)
    brand.name = brands(:cards_and_more).name

    assert brand.save
    assert_equal "cards-more-#{brand.id}", brand.reload.handle
  end

  test "changing brand name to the same name should not cause handle change" do
    @brand.name = "Maple Skin"
    assert @brand.save
    assert_equal "maple-skin", @brand.reload.handle
  end

  test "city should only contain alphabets" do
    @brand.city = "123"
    refute @brand.save
    assert_equal ["City should only contain letters"], @brand.errors.full_messages

    @brand.city = "Mumbai$%"
    refute @brand.save
    assert_equal ["City should only contain letters"], @brand.errors.full_messages

    @brand.city = "Ahmednagar"
    assert @brand.save
    assert_equal "Ahmednagar", @brand.reload.city
  end

  test "city is capitalized before saving" do
    @brand.city = "ahmednagar"
    assert @brand.save
    assert_equal "Ahmednagar", @brand.reload.city
  end

  test "state must be a valid Indian state" do
    @brand.state = "random"
    refute @brand.save
    assert_equal ["State is not a valid Indian state"], @brand.errors.full_messages
  end

  test "two brands cannot be created for one user" do
    brand = Brand.new(new_brand_params.merge(owner: users(:dibs)))
    refute brand.save
    assert_equal ["Owner has already created a brand"], brand.errors.full_messages
  end

  test "brand attributes have correct values after a valid creation" do
    user = users(:dibs)
    destroy_brand(user.brand)

    brand = user.build_brand(new_brand_params)

    assert brand.save
    assert_equal 'Cool New Brand', brand.reload.name
    assert_equal 'Cool New Brand is not so cool.', brand.story
    assert_equal 'cool-new-brand', brand.handle
    assert_equal 'Mumbai', brand.city
    assert_equal 'Maharashtra', brand.state
    assert_equal user, brand.owner
  end

  test "brand has many products" do
    brand = brands(:maple_skin)
    assert brand.products.any?
    assert_equal 3, brand.products.count
  end

  test "products should get destroyed if the Brand is" do
    assert_difference 'Product.count', -3 do
      brand = brands(:maple_skin)
      assert destroy_brand(brand)
    end
  end

  private

  def new_brand_params
    {
      name: 'Cool New Brand',
      story: 'Cool New Brand is not so cool.',
      city: 'Mumbai',
      state: 'Maharashtra'
    }
  end

  def destroy_brand(brand)
    Cart.destroy_all
    brand.destroy
  end
end
