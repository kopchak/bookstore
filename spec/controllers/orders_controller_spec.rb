require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  before do
    @customer = create(:customer)
    @order = create(:order, customer_id: @customer.id)
    cookies[:order_id] = @order.id
  end

  describe 'GET #index' do
    context 'when customer has been sign_in' do
      it 'render index template' do
        sign_in @customer
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign in page' do
        get :index
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :manage, Order
      end

      it 'redirect to root' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #show' do
    context 'when customer has been sign_in' do
      it 'render show template' do
        sign_in @customer
        get :show, id: @order.id
        expect(response).to render_template(:show)
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign in page' do
        get :show, id: @order.id
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :manage, Order
      end

      it 'redirect to root' do
        get :show, id: @order.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #complete' do
    context 'when customer has been sign_in' do
      it 'render overview template' do
        sign_in @customer
        get :complete, id: @order.id
        expect(response).to render_template(:complete)
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign in page' do
        get :complete, id: @order.id
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :manage, Order
      end

      it 'redirect to root' do
        get :complete, id: @order.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #add_discount' do
    it 'redirect to where you came from a request' do
      request.env["HTTP_REFERER"] = order_items_path
      patch :add_discount, id: @order.id, discount: attributes_for(:discount)
      expect(response).to redirect_to(order_items_path)
    end
  end

  describe 'DELETE #clear_cart' do
    it 'redirect to order_items_path' do
      delete :clear_cart
      expect(response).to redirect_to(order_items_path)
    end
  end
end
