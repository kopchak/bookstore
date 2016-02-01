class CategoriesController < ApplicationController
  load_and_authorize_resource
  
  def show
    @books = Book.where(category_id: params[:id]).page(params[:page]).per(6)
    order = Order.find(cookies[:order_id])
    @order_items_count = order.order_items.sum(:quantity)
    @order_items_price = order.order_items.sum(:price)
    if @books.empty?
      redirect_to books_path
    else
      @categories = Category.all
    end
  end
end
