require 'rails_helper'

RSpec.describe OrderItemsController, :type => :controller do
  before do
    @book = create(:book)
    @order = create(:order)
    cookies[:order_id] = @order.id
    @order_item = create(:order_item, order_id: @order.id)
  end

  describe 'GET #index' do
    context 'when can' do
      it 'render edit template' do
        get :index
        expect(response).to render_template(:index)
      end
    end
    

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        @customer = create(:customer)
        sign_in @customer
        @ability.cannot :manage, OrderItem
      end

      it 'redirect to root' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when can' do
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

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        @customer = create(:customer)
        sign_in @customer
        @ability.cannot :manage, OrderItem
      end

      it 'redirect to root' do
        post :create, order_item: attributes_for(:order_item, book_id: @book.id)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when can' do
      it 'render nothing' do
        patch :update, id: @order_item.id, order_item: attributes_for(:order_item)
        expect(response.body).to be_blank
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        @customer = create(:customer)
        sign_in @customer
        @ability.cannot :manage, OrderItem
      end

      it 'redirect to root' do
        patch :update, id: @order_item.id, order_item: attributes_for(:order_item)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #destroy' do
    context 'when can' do
      it 'redirect to order_items_path' do
        delete :destroy, id: @order_item.id
        expect(response).to redirect_to(order_items_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        @customer = create(:customer)
        sign_in @customer
        @ability.cannot :manage, OrderItem
      end

      it 'redirect to root' do
        delete :destroy, id: @order_item.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
