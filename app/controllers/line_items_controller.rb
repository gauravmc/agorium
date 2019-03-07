class LineItemsController < ApplicationController
  include CartHelper

  before_action :set_brand, :set_product

  def create
    @line_item = current_cart.add_product(@product)

    respond_to do |format|
      if @line_item.save
        format.js { render :create }
      else
        flash[:danger] = "Product could not be added to cart. Please try again."
        format.js { redirect_to storefront_path(@brand.handle) }
      end
    end
  end

  private

  def set_brand
    @brand = Brand.find(line_item_params[:brand_id])
  end

  def set_product
    @product = @brand.products.find(line_item_params[:product_id])
  end

  def line_item_params
    params.require(:line_item).permit(:brand_id, :product_id)
  end
end
