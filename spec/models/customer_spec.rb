require 'rails_helper'

RSpec.describe Customer, :type => :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:ratings) }
  it { is_expected.to belong_to(:billing_address) }
  it { is_expected.to belong_to(:shipping_address) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_presence_of(:encrypted_password) }
  it { is_expected.to accept_nested_attributes_for(:billing_address) }
  it { is_expected.to accept_nested_attributes_for(:shipping_address) }

  # context 'after create address exist' do
  #   before do
  #     @customer = create(:customer)
  #   end

  #   it 'billing address not nil' do
  #     expect(@customer.billing_address).not_to be_nil
  #   end

  #   it 'shipping address not nil' do
  #     expect(@customer.shipping_address).not_to be_nil
  #   end
  # end

  context 'self#from_omniauth' do
    before do
      @customer_data = OmniAuth.config.mock_auth[:facebook]
    end

    it 'create customer' do
      expect(Customer.all).to be_empty
      expect{ Customer.from_omniauth(@customer_data) }.to change{ Customer.count }.by(1)
      expect(Customer.all).not_to be_empty
    end
  end

  context '#current_order' do
    before do
      @customer = create(:customer)
    end

    it 'return order where state in_progress' do
      @order = create(:order, customer_id: @customer.id)
      expect(@customer.current_order.state).to eq('in_progress')
    end

    it 'return nil if no have order state in_progress' do
      @order = create(:order, customer_id: @customer.id, state: 'in_queue')
      expect(@customer.current_order).to be_nil
    end
  end
end