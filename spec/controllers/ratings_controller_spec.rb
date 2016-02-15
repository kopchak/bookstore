require 'rails_helper'

RSpec.describe RatingsController, :type => :controller do
  before do
    @customer = create(:customer)
    @book = create(:book)
    @order = create(:order, customer_id: @customer.id)
    cookies[:order_id] = @order.id
  end

  describe 'GET #new' do
    context 'when customer sign in' do
      it 'render edit template' do
        sign_in @customer
        get :new, book_id: @book.id
        expect(response).to render_template(:new)
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign_in page' do
        get :new, book_id: @book.id
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :new, Rating
      end

      it 'redirect to root' do
        get :new, book_id: @book.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'POST #create' do
    context 'when customer sign in' do
      before do
        sign_in @customer
      end

      it 'successful response with valid params' do
        post :create, book_id: @book.id, rating: attributes_for(:rating, customer_id: @customer.id)
        expect(response).to redirect_to(book_path(@book.id))
      end

      it 'render new with invalid params' do
        post :create, book_id: @book.id, rating: attributes_for(:rating)
        expect(response).to render_template(:new)
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign_in page' do
        post :create, book_id: @book.id, rating: attributes_for(:rating)
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :create, Rating
      end

      it 'redirect to root' do
        post :create, book_id: @book.id, rating: attributes_for(:rating)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
