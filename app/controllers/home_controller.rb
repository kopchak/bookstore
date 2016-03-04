class HomeController < ApplicationController
  before_action :current_order

  def index
    @order_item = OrderItem.new
    @bestsellers_books = Book.bestsellers
  end
end
