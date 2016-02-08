require 'rails_helper'

RSpec.describe CreditCard, :type => :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to validate_presence_of(:number).on(:update) }
  it { is_expected.to validate_presence_of(:expiration_month).on(:update) }
  it { is_expected.to validate_presence_of(:expiration_year).on(:update) }
  it { is_expected.to validate_presence_of(:cvv).on(:update) }
end