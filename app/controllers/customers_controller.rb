class CustomersController < ApplicationController
  load_and_authorize_resource
  before_action :get_order_info, only: :edit

  def edit
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def update
    if params[:billing_address]
      current_user.billing_address.update(billing_params)
    elsif params[:shipping_address]
      current_user.shipping_address.update(shipping_params)
    end
    redirect_to :back
  end

  private
  def billing_params
    params.require(:billing_address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone, :id)
  end

  def shipping_params
    params.require(:shipping_address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone, :id)
  end
end
