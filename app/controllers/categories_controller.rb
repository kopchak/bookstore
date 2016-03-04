class CategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :current_order

  def show
    @books = Book.where(category_id: params[:id]).page(params[:page]).per(6)
    @categories = Category.has_book
  end
end
