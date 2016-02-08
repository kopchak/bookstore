class OrderItemsController < ApplicationController
  load_and_authorize_resource
  before_action :check_order_id, only: [:index, :create]
  before_action :get_order_id, only: [:index, :create, :clear_cart]

  def index
    @order_items = @order.order_items
    @order_items_price = @order.order_items.sum(:price)
    @discount = Discount.new
  end

  def create
    book = Book.find(params[:order_item][:book_id])
    if order_item = @order.order_items.find_by(book_id: params[:order_item][:book_id])
      order_item.quantity += order_item_params[:quantity].to_i
      order_item.price += book.price * order_item_params[:quantity].to_i
    else
      order_item = @order.order_items.new(order_item_params)
      order_item.price = book.price * order_item_params[:quantity].to_i
    end
    order_item.save
    redirect_to :back
  end

  def update
    @order_item.update(order_item_params)
    render nothing: true
  end

  def destroy
    @order_item.destroy
    redirect_to :back
  end

  def clear_cart
    @order.order_items.destroy_all
    redirect_to :back
  end

  private
  def order_item_params
    params.require(:order_item).permit(:quantity, :book_id, :price)
  end
end
