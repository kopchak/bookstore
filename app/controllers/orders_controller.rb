class OrdersController < ApplicationController
  before_action :check_order_id, :check_current_user, only: :index
  load_and_authorize_resource
  before_action :get_order_info, only: [:index, :show]

  def index
    orders = Order.accessible_by(current_ability)
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
end
