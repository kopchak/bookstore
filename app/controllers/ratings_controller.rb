class RatingsController < ApplicationController
  load_and_authorize_resource

  def new
    @book = Book.find(params[:book_id])
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
  end

  def create
    @book = Book.find(params[:book_id])
    @rating = Rating.new(rating_params)
    if @rating.save
      @book.ratings << @rating
      redirect_to book_path(@book)
    else
      render 'new'
    end
  end

  private
    def rating_params
      params.require(:rating).permit(:rating, :title, :review, :customer_id)
    end
end
