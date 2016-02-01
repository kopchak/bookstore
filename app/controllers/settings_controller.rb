class SettingsController < ApplicationController
  load_and_authorize_resource class: 'Address'
  before_action :create_address_if_nil, only: :index

  def index
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def update_address
    address = Address.find(params[:id])
    address.update(setting_params)
    redirect_to :back
  end

  private
    def setting_params
      params.require(:address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone)
    end
end
