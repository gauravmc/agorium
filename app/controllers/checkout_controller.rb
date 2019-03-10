class CheckoutController < StorefrontController
  def new
    @customer = Customer.new
    @customer.build_address
    @line_items = current_cart.line_items.preload(:product)
  end

  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.valid?
        Order.generate(@customer, current_cart)
        reset_cart
        flash[:success] = "Thank you for placing an order with us. We will ship it to you very soon!"
        format.js { redirect_to storefront_path(current_brand.handle) }
      else
        format.js { render :create, status: :unprocessable_entity }
      end
    end
  end

  private

  def reset_cart
    current_cart.destroy
    create_cart
  end

  def navigation_type
    :breadcrumb
  end

  def customer_params
    params.require(:customer).permit(:name, :phone, address_attributes: [:address_line_1, :address_line_2, :landmark, :city, :state, :pincode])
  end
end