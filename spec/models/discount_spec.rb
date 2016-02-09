require 'rails_helper'

RSpec.describe Discount, :type => :model do
  it { is_expected.to have_many(:orders) }
  it { is_expected.to validate_presence_of(:amount) }

    it 'after create code not nil' do
      discount = create(:discount)
      expect(discount.code).not_to be_nil
    end
end
