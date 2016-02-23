require 'rails_helper'

RSpec.describe CheckoutsController, type: :controller do
  before do
    @address = create(:address)
    @customer = create(:customer)
    @order = create(:order, customer_id: @customer.id)
    cookies[:order_id] = @order.id
  end

  describe 'GET #edit_address' do
    context 'when customer has been sign_in' do
      it 'render edit_address template' do
        sign_in @customer
        get :edit_address
        expect(response).to render_template(:edit_address)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        get :edit_address
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end

  describe 'PATCH #update_address' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
        allow(controller).to receive(:current_user).and_return(@customer)
      end

      it 'with params[:use_billing_address]' do
        patch :update_address, use_billing_address: true, customer: { 
                                                    billing_address_attributes: attributes_for(:address)
                                                  }
        expect(@customer.billing_address.firstname).to eq(@customer.shipping_address.firstname)
      end

      it 'without params[:use_billing_address]' do
        patch :update_address, customer: { 
                                  billing_address_attributes: attributes_for(:address),
                                  shipping_address_attributes: attributes_for(:address)
                       }
        expect(@customer.billing_address.firstname).not_to eq(@customer.shipping_address.firstname)
      end

      it 'response redirect to choose_deliveries_path' do
        patch :update_address, use_billing_address: true, customer: { 
                                                    billing_address_attributes: attributes_for(:address)
                                                  }
        expect(response).to redirect_to(checkouts_choose_delivery_path)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        patch :update_address
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end

  describe 'GET #choose_delivery' do
    context 'when customer has been sign_in' do
      it 'render choose_delivery template' do
        sign_in @customer
        get :choose_delivery
        expect(response).to render_template(:choose_delivery)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        get :choose_delivery
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end

  describe 'PATCH #set_delivery' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
        @delivery = create(:delivery)
        patch :set_delivery, order: { delivery_id: @delivery.id }
      end

      it 'with valid params' do
        @order.reload
        expect(@order.delivery_id).to eq(@delivery.id)
      end

      it 'response redirect to confirm_payment_path' do
        expect(response).to redirect_to(checkouts_confirm_payment_path)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        patch :set_delivery
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end

  describe 'GET #confirm_payment' do
    context 'when customer has been sign_in' do
      it 'render confirm_payment template' do
        sign_in @customer
        get :confirm_payment
        expect(response).to render_template(:confirm_payment)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        get :confirm_payment
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end

  describe 'PATCH #update_credit_card' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
        @cc_params = attributes_for(:credit_card)
        patch :update_credit_card, credit_card: @cc_params
      end

      it 'with valid params' do
        @order.reload
        expect(@order.credit_card.number).to eq(@cc_params[:number])
      end

      it 'response redirect to overview_path' do
        expect(response).to redirect_to(checkouts_overview_path)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        patch :update_credit_card
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end

  describe 'GET #overview' do
    context 'when customer has been sign_in' do
      it 'render overview template' do
        sign_in @customer
        get :overview
        expect(response).to render_template(:overview)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        get :overview
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end

  describe 'PATCH #confirmation' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
      end

      it 'delete cookies' do
        expect(cookies[:order_id]).to eq(@order.id)
        patch :confirmation
        expect(cookies[:order_id]).to be_nil
      end

      it 'response redirect to complete_order_path' do
        patch :confirmation
        expect(response).to redirect_to(complete_order_path(@order.id))
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        patch :confirmation
        expect(response).to redirect_to(new_customer_session_path)
      end
    end
  end
end
