class AddressesController < ApplicationController
  load_and_authorize_resource
  before_action :create_address_if_nil, :create_credit_card_if_nil, only: :edit
  
  def edit
    @order = Order.find(cookies[:order_id])
    @order_items_count = @order.order_items.sum(:quantity)
    @order_items_price = @order.order_items.sum(:price)
  end

  def update
    if params[:use_billing_address]
      current_user.billing_address.update(billing_params)
      current_user.shipping_address.update(billing_params)
    else
      current_user.billing_address.update(billing_params)
      current_user.shipping_address.update(shipping_params)
    end
    current_user.save
    redirect_to deliveries_path
  end
  
  private
    def billing_params
      params.require(:customer).require(:billing_address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone)
    end

    def shipping_params
      params.require(:customer).require(:shipping_address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone)
    end
end
