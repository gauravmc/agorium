class CheckoutController < StorefrontController
  def new
    @customer = Customer.new
    @customer.build_address
    @line_items = current_cart.line_items.preload(:product)
  end

  private

  def navigation_type
    :breadcrumb
  end
end
