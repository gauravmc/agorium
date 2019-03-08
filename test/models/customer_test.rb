require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "name must exist" do
    customer = Customer.new(phone: 9999999999)
    refute customer.save
    assert_equal ["Name can't be blank"], customer.errors.full_messages

    customer = Customer.new(name: '', phone: 9999999999)
    refute customer.save
    assert_equal ["Name can't be blank"], customer.errors.full_messages
  end

  test "name must not be ridiculously long (above 255 chars)" do
    bad_name = "A" * 257
    customer = Customer.new(name: bad_name, phone: 9999999999)
    refute customer.save
    assert_equal ["Name is too long (maximum is 255 characters)"], customer.errors.full_messages
  end

  test "phone must exist as a number" do
    customer = Customer.new(name: 'Dibs')
    refute customer.save
    assert_equal ["Phone should be a 10-digit number"], customer.errors.full_messages

    customer = Customer.new(name: 'Dibs', phone: '')
    refute customer.save
    assert_equal ["Phone should be a 10-digit number"], customer.errors.full_messages

    customer = Customer.new(name: 'Dibs', phone: 'Bob')
    refute customer.save
    assert_equal ["Phone should be a 10-digit number"], customer.errors.full_messages

    customer = Customer.new(name: 'Dibs', phone: '+999876767')
    refute customer.save
    assert_equal ["Phone should be a 10-digit number"], customer.errors.full_messages
  end

  test "phone must be 10 digits" do
    customer = Customer.new(name: 'Dibs', phone: 123456789)
    refute customer.save
    assert_equal ["Phone should be a 10-digit number"], customer.errors.full_messages

    customer = Customer.new(name: 'Dibs', phone: 1234567891011012)
    refute customer.save
    assert_equal ["Phone should be a 10-digit number"], customer.errors.full_messages
  end

  test "phone must be unique" do
    customer = Customer.new(name: 'Dibs', phone: 9890801111)
    refute customer.save
    assert_equal ["Phone has already been taken"], customer.errors.full_messages
  end

  test "phone_verified is false by default" do
    customer = Customer.create!(name: 'Garr', phone: '9604884000')
    refute customer.phone_verified
  end

  test "phone_successfully_verified! updates phone_verified to true" do
    customer = Customer.create!(name: 'Garr', phone: '9604884000')
    customer.phone_successfully_verified!
    customer.reload
    assert customer.phone_verified?
  end
end
