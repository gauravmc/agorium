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
    assert_equal ["Phone should be a 10-digit number"], user.errors.full_messages

    user = User.new(name: 'Dibs', phone: '')
    refute user.save
    assert_equal ["Phone should be a 10-digit number"], user.errors.full_messages

    user = User.new(name: 'Dibs', phone: 'Bob')
    refute user.save
    assert_equal ["Phone should be a 10-digit number"], user.errors.full_messages

    user = User.new(name: 'Dibs', phone: '+999876767')
    refute user.save
    assert_equal ["Phone should be a 10-digit number"], user.errors.full_messages
  end

  test "phone must be 10 digits" do
    user = User.new(name: 'Dibs', phone: 123456789)
    refute user.save
    assert_equal ["Phone should be a 10-digit number"], user.errors.full_messages

    user = User.new(name: 'Dibs', phone: 1234567891011012)
    refute user.save
    assert_equal ["Phone should be a 10-digit number"], user.errors.full_messages
  end

  test "phone must be unique" do
    user = User.new(name: 'Dibs', phone: 4242424242)
    refute user.save
    assert_equal ["Phone has already been taken"], user.errors.full_messages
  end

  test "phone_verified is false by default" do
    user = User.create!(name: 'Garr', phone: '9604884000')
    refute user.phone_verified
  end

  test "phone_successfully_verified! updates phone_verified to true" do
    user = User.create!(name: 'Garr', phone: '9604884000')
    user.phone_successfully_verified!
    user.reload
    assert user.phone_verified?
  end

  test "remember updates the remember_digest with an encrypted token" do
    user = User.create!(name: 'Garr', phone: '9604884000')
    user.remember
    assert user.remember_digest.present?
  end

  test "forget sets remember_digest to nil" do
    user = users(:dibs)
    user.update_attribute(:remember_digest, User.digest(42))
    user.forget
    refute user.remember_digest.present?
  end

  test "authenticated? should return false for a user with nil digest" do
    user = users(:dibs)
    user.update_attribute(:remember_digest, nil)
    refute user.authenticated?('')
  end

  test "must create user if everything is okay" do
    user = User.new(name: 'Garr', phone: '9604884000')
    assert user.save
    assert user.id
  end

  test "user has many products" do
    user = users(:dibs)
    assert user.products.any?
    assert_equal 3, user.products.count
  end
end
