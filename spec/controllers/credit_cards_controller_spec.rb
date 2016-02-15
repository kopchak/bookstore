require 'rails_helper'

RSpec.describe CreditCardsController, :type => :controller do
  before do
    @customer = create(:customer)
    @order = create(:order, customer_id: @customer.id)
    cookies[:order_id] = @order.id
  end

  describe 'GET #edit' do
    context 'when customer sign in' do
      it 'render edit template' do
        sign_in @customer
        get :edit, id: @order.credit_card.id
        expect(response).to render_template(:edit)
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign_in page' do
        get :edit, id: @order.credit_card.id
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :manage, CreditCard
      end

      it 'redirect to root' do
        patch :update, id: @order.credit_card.id, credit_card: attributes_for(:credit_card)
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "PATCH #update" do
    context 'when customer sign in' do
      it 'successful response with valid params' do
        sign_in @customer
        patch :update, id: @order.credit_card.id, credit_card: attributes_for(:credit_card)
        expect(response).to redirect_to(edit_order_path(@order.id))
      end
    end

    context 'when customer not sign in' do
      it 'redirect to sign_in page' do
        patch :update, id: @order.credit_card.id, credit_card: attributes_for(:credit_card)
        expect(response).to redirect_to(new_customer_session_path)
      end
    end

    context 'when no have rights, cancan redirect to root path' do
      before do
        redefine_cancan_abilities
        sign_in @customer
        @ability.cannot :manage, CreditCard
      end

      it 'redirect to root' do
        patch :update, id: @order.credit_card.id, credit_card: attributes_for(:credit_card)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
