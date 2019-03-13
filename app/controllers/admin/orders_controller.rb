class Admin::OrdersController < AdminController
  def index
    @orders = current_brand.orders.includes(:customer)
  end
end
