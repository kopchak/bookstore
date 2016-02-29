class OrderItemsController < ApplicationController
  load_and_authorize_resource
  before_action :check_order_id, only:  :index

  def index
    @order_items = @order.order_items
    @order_items_price = @order.items_price
    @discount = Discount.new
  end

  def create
    @order.add_book(params[:order_item][:book_id], params[:order_item][:quantity].to_i)
    redirect_to :back
  end

  def update
    @order_item.update(order_item_params)
    render nothing: true
  end

  def destroy
    @order_item.destroy
    redirect_to order_items_path
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id, :price)
  end
end
