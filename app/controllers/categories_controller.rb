class CategoriesController < ApplicationController
  before_action :check_order_id, :get_order_info
  load_and_authorize_resource
  
  def show
    @books = Book.where(category_id: params[:id]).page(params[:page]).per(6)
    @categories = Category.has_book
  end
end
