require 'rails_helper'

RSpec.describe OrdersController, :type => :controller do
  before do
    @customer = create(:customer)
    @order = create(:order, customer_id: @customer.id)
    @delivery = create(:delivery)
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

  describe 'GET #edit' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
      end

      it 'render edit template' do
        allow(controller).to receive(:check_payment).and_return(false)
        get :edit, id: @order.id
        expect(response).to render_template(:edit)
      end

      it 'redirect to back' do
        request.env["HTTP_REFERER"] = root_path
        get :edit, id: @order.id
        expect(response).to redirect_to(root_path)
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign in page' do
        get :edit, id: @order.id
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
        get :edit, id: @order.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when customer has been sign_in' do
      it 'redirect to credit card path' do
        sign_in @customer
        patch :update, id: @order.id, order: { delivery_id: @delivery.id }
        expect(response).to redirect_to(edit_credit_card_path(@order.credit_card.id))
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign in page' do
        patch :update, id: @order.id
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
        patch :update, id: @order.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #confirmation' do
    context 'when customer has been sign_in' do
      it 'redirect to overview order path' do
        sign_in @customer
        get :confirmation, id: @order.id
        expect(response).to redirect_to(overview_order_path(@order.id))
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign in page' do
        get :confirmation, id: @order.id
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
        get :confirmation, id: @order.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET #overview' do
    context 'when customer has been sign_in' do
      it 'render overview template' do
        sign_in @customer
        get :overview, id: @order.id
        expect(response).to render_template(:overview)
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
        get :overview, id: @order.id
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
end
