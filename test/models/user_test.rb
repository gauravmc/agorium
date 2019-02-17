require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "name must exist" do
    user = User.new(phone: 9999999999)
    refute user.save
    assert_equal ["Name can't be blank"], user.errors.full_messages

    user = User.new(name: '', phone: 9999999999)
    refute user.save
    assert_equal ["Name can't be blank"], user.errors.full_messages
  end

  test "name must not be ridiculously long (above 255 chars)" do
    bad_name = "A" * 257
    user = User.new(name: bad_name, phone: 9999999999)
    refute user.save
    assert_equal ["Name is too long (maximum is 255 characters)"], user.errors.full_messages
  end

  test "phone must exist as a number" do
    user = User.new(name: 'Dibs')
    refute user.save
    assert_equal ["Phone is not a number"], user.errors.full_messages

    user = User.new(name: 'Dibs', phone: '')
    refute user.save
    assert_equal ["Phone is not a number"], user.errors.full_messages

    user = User.new(name: 'Dibs', phone: 'Bob')
    refute user.save
    assert_equal ["Phone is not a number"], user.errors.full_messages
  end

  test "phone must be 10 digits" do
    user = User.new(name: 'Dibs', phone: 123456789)
    refute user.save
    assert_equal ["Phone is the wrong length (should be 10 characters)"], user.errors.full_messages

    user = User.new(name: 'Dibs', phone: 1234567891011012)
    refute user.save
    assert_equal ["Phone is the wrong length (should be 10 characters)"], user.errors.full_messages
  end

  test "phone must be unique" do
    user = User.new(name: 'Dibs', phone: 4242424242)
    refute user.save
    assert_equal ["Phone has already been taken"], user.errors.full_messages
  end

  test "must create user if everything is okay" do
    user = User.new(name: 'Garr', phone: '9604884000')
    assert user.save
    assert user.id
  end
end
