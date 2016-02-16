class CustomersController < ApplicationController
  load_and_authorize_resource
  before_action :get_order_info, only: :edit

  def edit
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def update_address
    if params[:billing_address]
      current_user.billing_address.update(billing_params)
    elsif params[:shipping_address]
      current_user.shipping_address.update(shipping_params)
    end
    redirect_to :back
  end

  def update_password
    @customer = Customer.find(current_user.id)
    if @customer.update_with_password(customer_params)
      sign_in @customer, :bypass => true
      redirect_to root_path
    else
      redirect_to edit_customer_path(current_user.id)
    end
  end

  def update_email
    @customer = Customer.find(current_user.id)
    current_user.update(customer_params)
    redirect_to edit_customer_path(current_user.id)
  end

  private
  def billing_params
    params.require(:billing_address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone, :id)
  end

  def shipping_params
    params.require(:shipping_address).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone, :id)
  end

  def customer_params
    params.require(:customer).permit(:current_password, :password, :email)
  end
end
