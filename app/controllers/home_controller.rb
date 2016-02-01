class HomeController < ApplicationController
  before_action :check_order_id, :check_current_user, only: :index

  def index
    @order_item = OrderItem.new
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
    @bestsellers_books = Book.joins(order_items: :order)
                        .where(orders: {state: ['in_queue','in_delivery','delivered']})
                        .select('books.id, books.price, books.image, books.description, books.title,
                          books.stock_qty, books.author_id, SUM(order_items.quantity) as quantity')
                        .group('books.id').order('quantity DESC').limit(3)
  end
end
