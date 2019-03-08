class CartController < ApplicationController
  layout 'storefront'
  include StorefrontHelper
  include CartHelper

  before_action :set_brand

  def show
    @line_items = current_cart.line_items.preload(:product)
  end
end
