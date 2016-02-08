class BooksController < ApplicationController
  before_action :check_order_id, :check_current_user, :get_order_info, only: [:index, :show]
  load_and_authorize_resource
  
  def index
    @books = @books.page(params[:page]).per(6)
    @categories = Category.joins(:books).distinct.order(:id)
  end

  def show
    @order_item = OrderItem.new
    @ratings = @book.ratings.accessible_by(current_ability)
  end
end
