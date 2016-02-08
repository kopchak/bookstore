class CreditCardsController < ApplicationController
  before_action :get_order_id, only: [:update, :check_delivery]
  before_action :get_order_info, :check_delivery, only: :edit
  load_and_authorize_resource

  def edit
    @credit_card = @order.credit_card
  end

  def update
    @order.credit_card.update(credit_card_params)
    redirect_to edit_order_path(@order.id)
  end

  private
  def credit_card_params
    params.require(:credit_card).permit(:number, :expiration_month, :expiration_year, :cvv)
  end

  def check_delivery
    unless @order.delivery_id
      redirect_to :back
    end
  end
end
