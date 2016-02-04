class OrdersController < ApplicationController
  load_and_authorize_resource
  before_action :check_order_id, :check_current_user, only: :index
  before_action :check_payment, only: :edit

  def index
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
    @orders_in_progress = current_user.orders.where(state: 'in_progress')
    @orders_in_queue = current_user.orders.where(state: 'in_queue')
    @orders_in_delivery = current_user.orders.where(state: 'in_delivery')
    @orders_delivered = current_user.orders.where(state: 'delivered')
  end

  def show
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
    @order = current_user.orders.find(params[:id])
  end

  def edit
    @order = Order.find(cookies[:order_id])
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
    @credit_card = @order.credit_card
    @order_items_count = @order.order_items.sum(:quantity)
    @order_items_price = @order.order_items.sum(:price)
  end

  def update
    order = Order.find(cookies[:order_id])
    delivery = Delivery.find(order_params[:delivery_id])
    if order.discount
      order.delivery = delivery
      order.total_price += delivery.price
    else
      order.delivery = delivery
      order.total_price = order.order_items.sum(:price) + delivery.price
    end
    order.save
    redirect_to edit_credit_card_path(order.credit_card.id)
  end

  def confirmation
    order = Order.find(cookies[:order_id])
    current_user.orders << order
    cookies.delete(:order_id)
    order.in_queue
    order.completed_date = 3.days.from_now
    order.save
    redirect_to action: 'overview'
  end

  def overview
    @order = Order.find(params[:id])
    @billing_address = current_user.billing_address
    @shipping_address = current_user.shipping_address
    @credit_card = @order.credit_card
  end

  def add_discount
    order = Order.find(cookies[:order_id])
    discount = Discount.find_by(discount_params)
    if discount && discount.new_state && order.discount.nil?
      discount.update(new_state: false)
      order.discount = discount
      order.total_price = order.order_items.sum(:price) - discount.amount
      order.save
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
      order = Order.find(cookies[:order_id])
      unless order.credit_card.number
        redirect_to :back
      end
    end
end
