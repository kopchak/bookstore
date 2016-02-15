class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :check_order_id, :check_current_user, only: :index
  before_action :get_order_info, only: [:index, :show, :edit]
  before_action :get_order_id,   only: [:update, :confirmation, :add_discount, :check_payment]
  before_action :check_payment,  only: :edit

  def index
    @orders_in_progress = Order.accessible_by(current_ability).where(state: 'in_progress')
    @orders_in_queue = Order.accessible_by(current_ability).where(state: 'in_queue')
    @orders_in_delivery = Order.accessible_by(current_ability).where(state: 'in_delivery')
    @orders_delivered = Order.accessible_by(current_ability).where(state: 'delivered')
  end

  def show
    @order = Order.accessible_by(current_ability).find(params[:id])
  end

  def edit
    @credit_card = @order.credit_card
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def update
    delivery = Delivery.find(order_params[:delivery_id])
    @order.delivery = delivery
    if @order.discount
      @order.total_price += delivery.price
    else
      @order.total_price = @order.order_items.sum(:price) + delivery.price
    end
    @order.save
    redirect_to edit_credit_card_path(@order.credit_card.id)
  end

  def confirmation
    current_user.orders << @order
    cookies.delete(:order_id)
    @order.in_queue
    @order.completed_date = 3.days.from_now
    @order.save
    check_order_id
    check_current_user
    redirect_to action: 'overview'
  end

  def overview
    @credit_card = @order.credit_card
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
  end

  def add_discount
    discount = Discount.find_by(discount_params)
    if discount && discount.new_state && @order.discount.nil?
      discount.update(new_state: false)
      @order.discount = discount
      @order.total_price = @order.order_items.sum(:price) - discount.amount
      @order.save
    end
    redirect_to :back
  end

  private
  def order_params
    params.require(:order).permit(:delivery_id)
  end

  def discount_params
    params.require(:discount).permit(:code)
  end

  def check_payment
    unless @order.credit_card.number
      redirect_to :back
    end
  end
end
