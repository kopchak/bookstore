class OrderItemsController < ApplicationController
  before_action :check_order_id, :get_order_id, only: [:index, :create]

  def index
    @order_items = @order.order_items
    @order_items_price = @order.items_price
    @discount = Discount.new
  end

  def create
    book = Book.find(params[:order_item][:book_id])
    order_item = @order.add_book(book, params[:order_item][:quantity])
    order_item.save
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
    redirect_to order_items_path
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id, :price)
  end
end
