class StorefrontController < ApplicationController
  layout 'storefront'

  before_action :set_brand

  def show
    @products = @brand.products.shuffle
  end

  private

  def set_brand
    @brand = Brand.find_by!(handle: params[:handle])
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = "Brand named '#{params[:handle]}' does not exist."
    redirect_to root_path
  end
end
