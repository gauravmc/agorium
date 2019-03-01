class Admin::ProductsController < AdminController
  def new
    @product = current_user.products.new
  end

  def create
    @product = current_user.products.new(product_params)

    respond_to do |format|
      if @product.save
        flash[:success] = "#{@product.name} was successfully added to your products!"
        format.html { redirect_to new_admin_product_path }
      else
        flash.now[:danger] = "Product could not be created because of some input errors."
        format.html { render :new, status: :unprocessable_entity }
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price, :cost, :inventory)
  end
end
