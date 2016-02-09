require 'rails_helper'

RSpec.describe Order, :type => :model do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:delivery) }
  it { is_expected.to belong_to(:discount) }
  it { is_expected.to belong_to(:credit_card) }
  it { is_expected.to have_many(:order_items) }
  it { is_expected.to accept_nested_attributes_for(:credit_card) }

  context 'after create exist credit card' do
    before do
      @order = create(:order)
    end

    it 'credit card not nil' do
      expect(@order.credit_card).not_to be_nil
    end
  end
end