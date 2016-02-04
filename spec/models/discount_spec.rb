require 'rails_helper'

RSpec.describe Discount, :type => :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to validate_presence_of(:amount) }
end
