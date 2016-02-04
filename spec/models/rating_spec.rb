require 'rails_helper'

RSpec.describe Rating, :type => :model do
  it { is_expected.to belong_to(:customer) }
  it { is_expected.to belong_to(:book) }
  it { is_expected.to validate_presence_of(:rating) }
  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:review) }
  it { is_expected.to validate_presence_of(:customer_id) }
end