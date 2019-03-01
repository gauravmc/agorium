class Admin::ProductsController < AdminController
  def new
    @product = current_user.products.new
  end
end
