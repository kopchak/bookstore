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

  context 'after create address exist' do
    before do
      @customer = create(:customer)
    end

    it 'billing address not nil' do
      expect(@customer.billing_address).not_to be_nil
    end

    it 'shipping address not nil' do
      expect(@customer.shipping_address).not_to be_nil
    end
  end
end