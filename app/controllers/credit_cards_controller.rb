class CreditCardsController < ApplicationController
  before_action :check_delivery, only: :edit
  load_and_authorize_resource

  def edit
    @order = Order.find(cookies[:order_id])
    @credit_card = @order.credit_card
    @order_items_count = @order.order_items.sum(:quantity)
    @order_items_price = @order.order_items.sum(:price)
  end

  def update
    order = Order.find(cookies[:order_id])
    order.credit_card.update(credit_card_params)
    redirect_to edit_order_path(order.id)
  end

  private
    def credit_card_params
      params.require(:credit_card).permit(:number, :expiration_month, :expiration_year, :cvv)
    end

    def check_delivery
      order = Order.find(cookies[:order_id])
      unless order.delivery_id
        redirect_to :back
      end
    end
end
