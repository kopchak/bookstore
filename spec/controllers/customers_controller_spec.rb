require 'rails_helper'

RSpec.describe CustomersController, :type => :controller do
  before do
    @address = create(:address)
    @customer = create(:customer)
    @order = create(:order, customer_id: @customer.id)
    cookies[:order_id] = @order.id
  end

  describe 'GET #edit' do
    context 'when customer has been sign_in' do
      it 'render edit template' do
        sign_in @customer
        get :edit, id: @customer.id
        expect(response).to render_template(:edit)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        get :edit, id: @customer.id
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :edit, Customer
      end

      it 'redirect to root' do
        get :edit, id: @customer.id
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update_address' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
        allow(controller).to receive(:current_user).and_return(@customer)
      end

      it 'with params[:billing_address]' do
        expect(@customer.billing_address.firstname).to be_nil
        patch :update_address, id: @customer.id, billing_address: attributes_for(:address)
        expect(@customer.billing_address.firstname).not_to be_nil
      end

      it 'with params[:shipping_address]' do
        expect(@customer.shipping_address.firstname).to be_nil
        patch :update_address, id: @customer.id, shipping_address: attributes_for(:address)
        expect(@customer.shipping_address.firstname).not_to be_nil
      end

      it 'response redirect to edit_customer_path' do
        patch :update_address, id: @customer.id, shipping_address: attributes_for(:address)
        expect(response).to redirect_to(edit_customer_path)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign_in page' do
        patch :update_address, id: @customer.id, billing_address: attributes_for(:address)
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :update_address, Customer
      end

      it 'redirect to root' do
        patch :update_address, id: @customer.id, billing_address: attributes_for(:address)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update_password' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
        allow(controller).to receive(:current_user).and_return(@customer)
      end

      it 'with valid params' do
        patch :update_password, id: @customer.id, customer: { current_password: @customer.password, password: '12345678' }
        expect(response).to redirect_to(root_path)
      end

      it 'with invalid params' do
        patch :update_password, id: @customer.id, customer: { current_password: 'blabla', password: '12345678' }
        expect(response).to redirect_to(edit_customer_path)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign_in page' do
        patch :update_password, id: @customer.id, customer: { current_password: @customer.password, password: '12345678' }
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :update_password, Customer
      end

      it 'redirect to root' do
        patch :update_password, id: @customer.id, customer: { current_password: @customer.password, password: '12345678' }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update_email' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
        allow(controller).to receive(:current_user).and_return(@customer)
      end

      it 'blabla' do
        patch :update_email, id: @customer.id, customer: { email: 'abrakadabra@gmail.com' }
        expect(@customer.email).to eq('abrakadabra@gmail.com')
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign_in page' do
        patch :update_email, id: @customer.id, customer: { email: 'abrakadabra@gmail.com' }
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :update_email, Customer
      end

      it 'redirect to root' do
        patch :update_email, id: @customer.id, customer: { email: 'abrakadabra@gmail.com' }
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
