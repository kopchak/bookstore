class RatingsController < ApplicationController
  before_action :get_order_info, only: :new
  load_and_authorize_resource

  def new
    @book = Book.find(params[:book_id])
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
