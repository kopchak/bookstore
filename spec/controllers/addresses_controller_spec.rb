require 'rails_helper'

RSpec.describe AddressesController, :type => :controller do
  before do
    @address = create(:address)
    @customer = create(:customer)
    @order = create(:order, customer_id: @customer.id)
    cookies[:order_id] = @order.id
  end

  describe "GET #edit" do
    context 'when customer has been sign_in' do
      it 'render edit template' do
        sign_in @customer
        get :edit
        expect(response).to render_template(:edit)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to sign in page' do
        get :edit
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :edit, Address
      end

      it 'redirect to root' do
        get :edit
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    context 'when customer has been sign_in' do
      before do
        sign_in @customer
        allow(controller).to receive(:current_user).and_return(@customer)
      end

      it 'with params[:use_billing_address]' do
        patch :update, use_billing_address: true, customer: { 
                                                    billing_address_attributes: attributes_for(:address) 
                                                  }
        expect(@customer.billing_address.firstname).to eq(@customer.shipping_address.firstname)
      end

      it 'without params[:use_billing_address]' do
        patch :update, customer: { 
                                  billing_address_attributes: attributes_for(:address),
                                  shipping_address_attributes: attributes_for(:address)
                       }
        expect(@customer.billing_address.firstname).not_to eq(@customer.shipping_address.firstname)
      end

      it 'response redirect to deliveries_path' do
        patch :update, use_billing_address: true, customer: { 
                                                    billing_address_attributes: attributes_for(:address) 
                                                  }
        expect(response).to redirect_to(deliveries_path)
      end
    end

    context 'when customer not sign_in' do
      it 'redirect to root' do
        patch :update
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :update, Address
      end

      it 'redirect to root' do
        patch :update, use_billing_address: true, customer: { 
                                                    billing_address_attributes: attributes_for(:address) 
                                                  }
        expect(response).to redirect_to(root_path)
      end
    end
  end

end
