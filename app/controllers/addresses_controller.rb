class AddressesController < ApplicationController
  load_and_authorize_resource
  before_action :get_order_info, only: :edit
  
  def edit
  end

  def update
    if params[:use_billing_address]
      current_user.billing_address.assign_attributes(billing_params)
      current_user.shipping_address.assign_attributes(billing_params)
    else
      current_user.billing_address.assign_attributes(billing_params)
      current_user.shipping_address.assign_attributes(shipping_params)
    end
    current_user.save
    redirect_to deliveries_path
  end
  
  private
  def billing_params
    params.require(:customer).require(:billing_address_attributes).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone)
  end

  def shipping_params
    params.require(:customer).require(:shipping_address_attributes).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone)
  end
end
