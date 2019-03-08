class AdminController < ApplicationController
  before_action :ensure_user_login, :ensure_account_setup_completed

  def index
    redirect_to admin_products_path
  end

  private

  def ensure_user_login
    redirect_to login_url unless logged_in?
  end

  def ensure_account_setup_completed
    redirect_to new_admin_brand_path if current_user.brand.nil?
  end

  def current_brand
    current_user.brand
  end
end
