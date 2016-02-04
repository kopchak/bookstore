require 'rails_helper'

RSpec.describe CreditCard, :type => :model do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to have_many(:orders) }
  it { is_expected.to validate_presence_of(:number) }
  it { is_expected.to validate_presence_of(:expiration_month) }
  it { is_expected.to validate_presence_of(:expiration_year) }
  it { is_expected.to validate_presence_of(:cvv) }
end