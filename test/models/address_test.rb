require 'test_helper'

class AddressTest < ActiveSupport::TestCase
  setup do
    @address = addresses(:vin_address)
  end

  test "address_line_1 cannot be blank" do
    @address.address_line_1 = ""
    refute @address.save
    assert_equal ["Address line 1 can't be blank"], @address.errors.full_messages
  end

  test "address_line_1 must be less than 255 characters" do
    @address.address_line_1 = "A" * 256
    refute @address.save
    assert_equal ["Address line 1 is too long (maximum is 255 characters)"], @address.errors.full_messages
  end

  test "address_line_2 can be blank but must be less than 255 characters if present" do
    @address.address_line_2 = ""
    assert @address.save

    @address.address_line_2 = "A" * 256
    refute @address.save
    assert_equal ["Address line 2 is too long (maximum is 255 characters)"], @address.errors.full_messages
  end

  test "landmark can be blank but must be less than 255 characters if present" do
    @address.landmark = ""
    assert @address.save

    @address.landmark = "A" * 256
    refute @address.save
    assert_equal ["Landmark is too long (maximum is 255 characters)"], @address.errors.full_messages
  end

  test "pincode must exist as a number" do
    @address.pincode = nil
    refute @address.save
    assert_equal ["Pincode should be a 6-digit number"], @address.errors.full_messages

    @address.pincode = ''
    refute @address.save
    assert_equal ["Pincode should be a 6-digit number"], @address.errors.full_messages

    @address.pincode = 'Bob'
    refute @address.save
    assert_equal ["Pincode should be a 6-digit number"], @address.errors.full_messages

    @address.pincode = '+99987'
    refute @address.save
    assert_equal ["Pincode should be a 6-digit number"], @address.errors.full_messages
  end

  test "pincode must be 6 digits" do
    @address.pincode = '9998'
    refute @address.save
    assert_equal ["Pincode should be a 6-digit number"], @address.errors.full_messages

    @address.pincode = '999987'
    assert @address.save
  end

  test "city should only contain alphabets" do
    @address.city = "123"
    refute @address.save
    assert_equal ["City should only contain letters"], @address.errors.full_messages

    @address.city = "Mumbai$%"
    refute @address.save
    assert_equal ["City should only contain letters"], @address.errors.full_messages

    @address.city = "Ahmednagar"
    assert @address.save
    assert_equal "Ahmednagar", @address.reload.city
  end

  test "city is capitalized before saving" do
    @address.city = "ahmednagar"
    assert @address.save
    assert_equal "Ahmednagar", @address.reload.city
  end

  test "state must be a valid Indian state" do
    @address.state = "random"
    refute @address.save
    assert_equal ["State is not a valid Indian state"], @address.errors.full_messages
  end
end
