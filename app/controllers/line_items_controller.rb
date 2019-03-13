class LineItemsController < StorefrontController
  before_action :set_product, only: [:create]

  def create
    @line_item = current_cart.add_product(@product)

    respond_to do |format|
      if @line_item.save
        @line_items = current_cart.line_items.includes(:product)
        format.js { render :create }
      else
        flash[:danger] = "Product could not be added to cart. Please try again."
        format.js { redirect_to storefront_path(current_brand.handle) }
      end
    end
  end

  def destroy
    @line_item = current_cart.line_items.find(params[:id])

    respond_to do |format|
      if @line_item.destroy
        @line_items = current_cart.line_items.includes(:product)
        format.js { render :destroy }
      else
        flash[:danger] = "Product could not be removed from cart. Please try again."
        format.js { redirect_to cart_path(current_brand.handle) }
      end
    end
  end

  private

  def set_product
    @product = current_brand.products.find(line_item_params[:product_id])
  end

  def line_item_params
    params.require(:line_item).permit(:brand_id, :product_id)
  end
end
