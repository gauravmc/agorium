class Admin::ProductsController < AdminController
  before_action :set_product, only: [:destroy]

  def index
    @products = current_brand.products.with_attached_photos
  end

  def new
    @product = current_brand.products.new
  end

  def create
    @product = current_brand.products.new(product_params)

    respond_to do |format|
      if @product.save
        flash[:success] = "#{@product.name} was successfully added to your products!"
        format.html { redirect_to admin_products_path }
      else
        flash.now[:danger] = "Product could not be created because of some input errors."
        format.html { render :new, status: :unprocessable_entity }
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy

    respond_to do |format|
      flash[:success] = "#{@product.name} was deleted from your products."
      format.html { redirect_to admin_products_path }
    end
  end

  private

  def set_product
    @product = current_brand.products.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :cost, :inventory, photos: [])
  end
end
