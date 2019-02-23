require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
  def setup
    @user = users(:dibs)
  end

  test "logging in user also remembers her with cookies" do
    log_in @user

    assert is_logged_in?
    assert cookies[:user_id].present?
    assert cookies[:remember_token].present?
    assert @user.remember_digest.present?
  end

  test "current_user returns right user when session is nil" do
    remember @user
    assert_equal @user, current_user
    assert is_logged_in?
  end

  test "current_user returns nil when remember digest is wrong" do
    remember @user
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end

  test "logging out user deletes it from cookies also" do
    log_in @user

    log_out
    refute is_logged_in?
    refute cookies[:user_id].present?
    refute cookies[:remember_token].present?
    refute @user.reload.remember_digest.present?
  end
end
