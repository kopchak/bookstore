require 'rails_helper'

RSpec.describe DeliveriesController, :type => :controller do
  before do
    @address = create(:address)
    @delivery = create(:delivery)
    @customer = create(:customer)
    @order = create(:order, customer_id: @customer.id)
    cookies[:order_id] = @order.id
  end

  describe 'GET #index' do
    context 'when customer has been sign_in' do
      before do
        allow(controller).to receive(:current_user).and_return(@customer)
        allow(@customer).to receive(:billing_address).and_return(@address)
      end

      it 'render index template' do
        get :index
        expect(response).to render_template(:index)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        get :index
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :index, Delivery
      end

      it 'redirect to root' do
        get :index
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
