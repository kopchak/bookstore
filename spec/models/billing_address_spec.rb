require 'rails_helper'

RSpec.describe BillingAddress, :type => :model do
  it { is_expected.to have_one(:customer) }
end