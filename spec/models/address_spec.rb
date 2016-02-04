require 'rails_helper'

RSpec.describe Address, :type => :model do
  it { is_expected.to validate_presence_of(:firstname) }
  it { is_expected.to validate_presence_of(:lastname) }
  it { is_expected.to validate_presence_of(:street_address) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:country) }
  it { is_expected.to validate_presence_of(:zipcode) }
  it { is_expected.to validate_presence_of(:phone) }
end