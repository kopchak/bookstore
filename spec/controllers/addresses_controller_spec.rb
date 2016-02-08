# require 'rails_helper'

# RSpec.describe AddressesController, :type => :controller do
#   before do
#     @address = create(:address)
#     @customer = create(:customer)
#     cookies[:order_id] = create(:order).id
#   end

#   describe "GET #edit" do
#     context 'when customer has been sign_in' do
#       it 'render edit template' do
#         sign_in @customer
#         get :edit
#         expect(response).to render_template(:edit)
#       end
#     end

#     context 'when customer not sign_in' do
#       it 'redirect to root' do
#         get :edit
#         expect(response).to redirect_to(new_customer_session_path)
#       end
#     end
#   end

#   describe 'PATCH #update' do
#     context 'when customer has been sign_in' do
#       it 'redirect to deliveries_path' do
#         sign_in @customer
#         # patch :update, customer: @customer
#         # expect(response).to render_template(:edit)
#       end
#     end

#     context 'when customer not sign_in' do
#       it 'redirect to root' do
#         get :update
#         expect(response).to redirect_to(new_customer_session_path)
#       end
#     end
#   end

# end
