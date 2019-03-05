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

  test "username cannot be longer than 42 characters" do
    bad_name = "A" * 43
    @brand.username = bad_name
    refute @brand.save
    assert_equal ["Username is too long (maximum is 42 characters)"], @brand.errors.full_messages
  end

  test "username is sanitized with lowercase alphabets" do
    @brand.username = 'A.B.C'
    assert @brand.save
    assert_equal "a.b.c", @brand.username
  end

  test "username must contain only alphabets, letters, underscores, and/or dots" do
    @brand.username = "A-B-C"
    refute @brand.save
    assert_equal ["Username should only have letters, numbers, underscores, and dots"], @brand.errors.full_messages

    @brand.username = "!@#$%^&"
    refute @brand.save
    assert_equal ["Username should only have letters, numbers, underscores, and dots"], @brand.errors.full_messages

    @brand.username = "a___...B"
    assert @brand.save
    assert_equal "a___...b", @brand.username
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
  end

  test "city is capitalized before saving" do
    @brand.city = "ahmednagar"
    assert @brand.save
    assert_equal "Ahmednagar", @brand.city
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
    user.brand.destroy
    brand = Brand.new(new_brand_params.merge(owner: user))

    assert brand.save
    assert_equal 'Cool New Brand', brand.name
    assert_equal 'Cool New Brand is not so cool.', brand.story
    assert_equal 'cool_new_brand', brand.username
    assert_equal 'Mumbai', brand.city
    assert_equal 'Maharashtra', brand.state
    assert_equal user, brand.owner
  end

  private

  def new_brand_params
    {
      name: 'Cool New Brand',
      story: 'Cool New Brand is not so cool.',
      username: 'cool_new_brand',
      city: 'Mumbai',
      state: 'Maharashtra'
    }
  end
end
