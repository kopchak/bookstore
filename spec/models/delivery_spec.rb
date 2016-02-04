require 'rails_helper'

RSpec.describe Delivery, :type => :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:title) }
end
