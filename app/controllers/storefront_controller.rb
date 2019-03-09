class StorefrontController < ApplicationController
  layout 'storefront'
  before_action :ensure_brand_exists
  helper_method :current_brand, :current_cart, :navigation_type

  def show
    @products = current_brand.products.shuffle
  end

  def show_cart
    @line_items = current_cart.line_items.preload(:product)
  end

  private

  def ensure_brand_exists
    @current_brand = Brand.find_by!(handle: params[:handle])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Brand named '#{params[:handle]}' does not exist."
    redirect_to root_path
  end

  def current_brand
    @current_brand
  end

  def current_cart
    key = "cart_id_#{current_brand.id}".to_sym
    @current_cart ||= Cart.find(session[key])
  rescue ActiveRecord::RecordNotFound
    @current_cart = Cart.create(brand: current_brand)
    session[key] = @current_cart.id
    @current_cart
  end

  def navigation_type
    :tabs
  end
end
