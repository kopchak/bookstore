class CheckoutsController < ApplicationController
  before_action :authenticate_customer!
  before_action :get_order_info, only: [:edit_address, :choose_delivery, :set_delivery, :confirm_payment, :update_credit_card, :overview]
  before_action :get_order_id,   only: :confirmation

  def edit_address
  end

  def update_address
    if params[:use_billing_address]
      current_user.billing_address.assign_attributes(billing_params)
      current_user.shipping_address.assign_attributes(billing_params)
    else
      current_user.billing_address.assign_attributes(billing_params)
      current_user.shipping_address.assign_attributes(shipping_params)
    end
    current_user.save
    redirect_to checkouts_choose_delivery_path
  end

  def choose_delivery
    @deliveries = Delivery.all
    @delivery = @order.delivery || @deliveries.first
  end

  def set_delivery
    delivery = Delivery.find(order_params[:delivery_id])
    @order.delivery = delivery
    @order.set_total_price
    @order.save
    redirect_to checkouts_confirm_payment_path
  end

  def confirm_payment
    @credit_card = @order.credit_card
  end

  def update_credit_card
    @order.credit_card.update(credit_card_params)
    redirect_to checkouts_overview_path
  end

  def overview
    @credit_card = @order.credit_card
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def confirmation
    current_user.orders << @order
    cookies.delete(:order_id)
    @order.in_queue
    @order.completed_date = 3.days.from_now
    @order.save
    # check_order_id
    # check_current_user
    redirect_to complete_order_path(@order.id)
  end

  private
  def billing_params
    params.require(:customer).require(:billing_address_attributes).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone)
  end

  def shipping_params
    params.require(:customer).require(:shipping_address_attributes).permit(:firstname, :lastname, :street_address, :city, :country, :zipcode, :phone)
  end

  def order_params
    params.require(:order).permit(:delivery_id)
  end

  def credit_card_params
    params.require(:credit_card).permit(:number, :expiration_month, :expiration_year, :cvv)
  end
end
