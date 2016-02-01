class OrderItemsController < ApplicationController
  before_action :check_order_id, only: [:create, :index]

  def index
    @order = Order.find(cookies[:order_id])
    @order_items = OrderItem.where(order_id: cookies[:order_id])
    @order_items_price = @order.order_items.sum(:price)
    @discount = Discount.new
  end

  def create
    order = Order.find(cookies[:order_id])
    if order_item = order.order_items.find_by(book_id: params[:order_item][:book_id])
      order_item.quantity += order_item_params[:quantity].to_i
      order_item.price += order_item_params[:price].to_f
      order_item.save
    else
      order_item = OrderItem.new(order_item_params)
      if order_item.save
        order.order_items << order_item
      end
    end
    redirect_to :back
  end

  def update
    order_item = OrderItem.find(params[:id])
    order_item.update(order_item_params)
    render nothing: true
  end

  def destroy
    order_item = OrderItem.find(params[:id])
    order_item.destroy
    redirect_to :back
  end

  def clear_cart
    order = Order.find(cookies[:order_id])
    order.order_items.destroy_all
    redirect_to :back
  end

  private
    def order_item_params
      params.require(:order_item).permit(:quantity, :book_id, :price)
    end
end
