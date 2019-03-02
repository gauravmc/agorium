class AdminController < ApplicationController
  before_action :ensure_user_login

  def index
    redirect_to admin_products_path
  end

  def ensure_user_login
    redirect_to login_url unless logged_in?
  end
end
