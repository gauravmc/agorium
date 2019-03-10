class Admin::OrdersController < AdminController
  def index
    @orders = current_brand.orders.preload(:customer)
  end
end
