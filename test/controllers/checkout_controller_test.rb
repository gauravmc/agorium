require 'test_helper'

class CheckoutControllerTest < ActionDispatch::IntegrationTest
  setup do
    @brand = brands(:maple_skin)
  end

  test "checkout_path renders the checkout page" do
    get checkout_url(@brand.handle)

    assert_response :success
    assert_match 'Street address', @response.body
    assert_match 'Order summary', @response.body
  end

  test "create renders errors when customer params are invalid" do
    params = customer_params
    params[:name] = ''

    post checkout_url(@brand.handle), params: { customer: params }, xhr: true

    assert_response :unprocessable_entity
    assert_equal "text/javascript", @response.content_type
    assert_match "Name can&#39;t be blank", @response.body
  end

  test "create creates records as expected when params are valid and resets cart" do
    cart = current_session_cart(@brand)

    assert_difference('Customer.count') do
      assert_difference('Order.count') do
        post checkout_url(@brand.handle), params: { customer: customer_params }, xhr: true
      end
    end

    assert_response :success
    assert_equal 'Thank you for placing an order with us. We will ship it to you very soon!', flash[:success]
    assert_equal "text/javascript", @response.content_type
    assert_match storefront_path(@brand.handle), @response.body
    assert_raise(ActiveRecord::RecordNotFound) do
      cart.reload
    end
  end

  private

  def customer_params
    {
      name: 'Shawn',
      phone: '4200420042',
      address_attributes: {
        address_line_1: '1234, Elita, Phase 42, Jayanagar',
        address_line_2: nil,
        landmark: nil,
        city: 'Bengaluru',
        state: 'Karnataka',
        pincode: '560008'
      }
    }
  end
end
