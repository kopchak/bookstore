require 'rails_helper'

RSpec.describe Address, :type => :model do
  it { is_expected.to validate_presence_of(:firstname).on(:update) }
  it { is_expected.to validate_presence_of(:lastname).on(:update) }
  it { is_expected.to validate_presence_of(:street_address).on(:update) }
  it { is_expected.to validate_presence_of(:city).on(:update) }
  it { is_expected.to validate_presence_of(:country).on(:update) }
  it { is_expected.to validate_presence_of(:zipcode).on(:update) }
  it { is_expected.to validate_presence_of(:phone).on(:update) }
end