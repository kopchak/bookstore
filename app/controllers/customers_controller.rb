class CustomersController < ApplicationController
  load_and_authorize_resource
  before_action :get_order_info, only: :edit

  def edit
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def update
    if current_user.billing_address.id == params[:address][:id].to_i || current_user.shipping_address.id == params[:address][:id].to_i
      address = Address.find(params[:address][:id])
      address.update(address_params)
    end
    redirect_to :back
  end

  private
  def address_params
    params.require(:address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone, :id)
  end
end
