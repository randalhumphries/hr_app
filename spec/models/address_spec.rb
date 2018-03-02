require 'rails_helper'

RSpec.describe Address, type: :model do
  
  it 'is valid with valid attibutes' do
    expect(build(:address)).to be_valid
  end

  it 'is valid without a state if not in the US' do
    expect(build(:address, state: nil, country: 'UK')).to be_valid
  end

  it 'is not valid without an address 1' do
    expect(build(:address, address_1: nil)).not_to be_valid
  end

  it 'is not valid without a city' do
    expect(build(:address, city: nil)).not_to be_valid
  end

  it 'is not valid without a state if in the US' do
    expect(build(:address, state: nil, country: 'US')).not_to be_valid
  end

  it 'is not valid without a zip code' do
    expect(build(:address, zip: nil)).not_to be_valid
  end

end
