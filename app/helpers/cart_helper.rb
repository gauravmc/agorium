module CartHelper
  private

  def current_cart
    key = "cart_id_#{@brand.id}".to_sym
    @current_cart ||= Cart.find(session[key])
  rescue ActiveRecord::RecordNotFound
    @current_cart = Cart.create(brand: @brand)
    session[key] = @current_cart.id
    @current_cart
  end
end
