class CategoriesController < ApplicationController
  before_action :get_order_info, only: :show
  load_and_authorize_resource
  
  def show
    @books = Book.where(category_id: params[:id]).page(params[:page]).per(6)
    @categories = Category.has_book
  end
end
