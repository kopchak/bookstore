require 'rails_helper'

RSpec.describe OrderItem, :type => :model do
  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:order) }
  it { is_expected.to validate_presence_of(:price) }
  it { is_expected.to validate_presence_of(:quantity) }
  it { is_expected.to validate_presence_of(:book_id) }
end