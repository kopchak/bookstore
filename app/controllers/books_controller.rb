class BooksController < ApplicationController
  load_and_authorize_resource
  before_action :current_order

  def index
    @books = @books.page(params[:page]).per(6)
    @categories = Category.has_book
  end

  def show
    @order_item = OrderItem.new
    @ratings = @book.ratings.accessible_by(current_ability)
  end
end
