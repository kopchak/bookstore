require 'rails_helper'

RSpec.describe Order, :type => :model do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:delivery) }
  it { is_expected.to belong_to(:discount) }
  it { is_expected.to belong_to(:credit_card) }
  it { is_expected.to have_many(:order_items) }
end