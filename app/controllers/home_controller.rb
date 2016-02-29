class HomeController < ApplicationController
  before_action :check_order_id, :check_current_user, :get_order_info

  def index
    @order_item = OrderItem.new
    @bestsellers_books = Book.bestsellers
  end
end
