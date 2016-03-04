class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :current_order, only: [:index, :show]
  before_action :assign_order_to_user, only: :index

  def index
    orders = current_user.orders.accessible_by(current_ability)
    @orders_in_progress = orders.in_progress
    @orders_in_queue = orders.in_queue
    @orders_in_delivery = orders.in_delivery
    @orders_delivered = orders.delivered
  end

  def show
  end

  def complete
    @credit_card = @order.credit_card
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def add_discount
    coupon = Discount.find_by(discount_params)
    @order.add_discount(coupon) if coupon
    redirect_to :back
  end

  def clear_cart
    @order.order_items.destroy_all
    redirect_to order_items_path
  end

  private
  def discount_params
    params.require(:discount).permit(:code)
  end

  def assign_order_to_user
    if current_order
      current_user.orders << current_order
    end
  end
end
