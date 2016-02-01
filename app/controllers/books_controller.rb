class BooksController < ApplicationController
  before_action :check_order_id, :check_current_user, only: [:index, :show]
  load_and_authorize_resource
  
  def index
    @books = Book.all.page(params[:page]).per(6)
    @categories = Category.all
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
  end

  def show
    @order_item = OrderItem.new
    @ratings = @book.ratings.where(check: true)
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
  end
end
