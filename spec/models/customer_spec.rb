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
end