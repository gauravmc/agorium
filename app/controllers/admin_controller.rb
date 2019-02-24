class AdminController < ApplicationController
  before_action :ensure_user_login

  def ensure_user_login
    redirect_to login_url unless logged_in?
  end
end
