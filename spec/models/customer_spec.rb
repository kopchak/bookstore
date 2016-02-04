require 'rails_helper'

RSpec.describe Customer, :type => :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to have_many(:ratings) }
  it { is_expected.to have_many(:credit_cards) }
  it { is_expected.to belong_to(:billing_address) }
  it { is_expected.to belong_to(:shipping_address) }
end