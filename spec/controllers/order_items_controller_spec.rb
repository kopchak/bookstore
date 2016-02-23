require 'rails_helper'

RSpec.describe OrderItemsController, :type => :controller do
  before do
    @book = create(:book)
    @order_item = create(:order_item)
    cookies[:order_id] = create(:order).id
  end

  context 'GET #index' do
    it 'render edit template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  context 'POST #create' do
    it 'redirect to root, if the request came from there' do
      request.env["HTTP_REFERER"] = root_path
      post :create, order_item: attributes_for(:order_item, book_id: @book.id)
      expect(response).to redirect_to(root_path)
    end

    it 'redirect to root, if the request came from there' do
      request.env["HTTP_REFERER"] = book_path(@book.id)
      post :create, order_item: attributes_for(:order_item, book_id: @book.id)
      expect(response).to redirect_to(book_path(@book.id))
    end
  end

  context 'PATCH #update' do
    it 'render nothing' do
      patch :update, id: @order_item.id, order_item: attributes_for(:order_item)
      expect(response.body).to be_blank
    end
  end

  context 'GET #destroy' do
    it 'redirect to order_items_path' do
      delete :destroy, id: @order_item.id
      expect(response).to redirect_to(order_items_path)
    end
  end

end
