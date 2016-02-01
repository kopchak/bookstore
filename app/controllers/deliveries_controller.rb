class DeliveriesController < ApplicationController
  before_action :check_address, only: :index
  load_and_authorize_resource
  
  def index
    @deliveries = Delivery.all
    @order = Order.find(cookies[:order_id])
    @order_items_count = @order.order_items.sum(:quantity)
    @order_items_price = @order.order_items.sum(:price)
    @ups_ground_price = 5
  end
end
