# require 'rails_helper'

# RSpec.describe CreditCardsController, :type => :controller do
#   before do
#     @credit_card = create(:credit_card)
#     @customer = create(:customer)
#     @delivery = create(:delivery)
#     @order = create(:order, delivery_id: @delivery.id, credit_card_id: @credit_card.id)
#     cookies[:order_id] = @order.id
#     redefine_cancan_abilities
#   end

#   context 'GET #edit' do
#     context 'when customer sign in' do
#       it 'render edit template' do
#         sign_in @customer
#         get :edit, id: @credit_card.id
#         expect(response).to render_template(:edit)
#       end
#     end

#     context 'when customer not sign in' do
#       it 'redirect to sign_in page' do
#         get :edit, id: @credit_card.id
#         expect(response).to redirect_to(new_customer_session_path)
#       end
#     end
#   end

#   context "PATCH #update" do
#     context 'when customer sign in' do
#       it 'successful response with valid params' do
#         sign_in @customer
#         patch :update, id: @credit_card.id, credit_card: attributes_for(:credit_card)
#         expect(response).to redirect_to(edit_order_path(@order.id))
#       end

#     end

#     context 'when customer not sign in' do
#       it 'redirect to sign_in page' do
#         patch :update, id: @credit_card.id, credit_card: attributes_for(:credit_card)
#         expect(response).to redirect_to(new_customer_session_path)
#       end
#     end

#     context 'cancan doesnt allow :update' do
#       before do
#         sign_in @customer
#         @ability.cannot :manage, CreditCard
#         patch :update, id: @credit_card.id, credit_card: attributes_for(:credit_card)
#       end

#       it { is_expected.to redirect_to root_path }
#     end
#   end
# end
