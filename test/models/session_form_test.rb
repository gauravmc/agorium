require 'test_helper'

class SessionFormTest < ActiveSupport::TestCase
  test "has correct error message when phone is invalid" do
    session_form = SessionForm.new(phone: 'Bob')
    refute session_form.valid?
    assert_equal ["Phone should be a 10-digit number"], session_form.errors.full_messages

    session_form = SessionForm.new(phone: '+999876767')
    refute session_form.valid?
    assert_equal ["Phone should be a 10-digit number"], session_form.errors.full_messages
  end

  test "has correct error message when user with given phone cannot be found" do
    session_form = SessionForm.new(phone: '9876567897')
    refute session_form.valid?
    assert_equal ["We couldn’t find an account with that number"], session_form.errors.full_messages
  end

  test "can return user instance if phone is valid" do
    session_form = SessionForm.new(phone: 4242424242)
    assert session_form.valid?
    assert session_form.user
    assert_equal session_form.user.id, users(:shawn).id
  end
end
