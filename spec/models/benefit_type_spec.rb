require 'rails_helper'

RSpec.describe BenefitType, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:benefit_type)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:benefit_type, name: nil)).not_to be_valid
  end

  it 'is not valid without an eligibility interval' do
    expect(build(:benefit_type, eligibility_interval: nil)).not_to be_valid
  end

  it 'is not valid without an eligibility interval unit' do
    expect(build(:benefit_type, eligibility_interval_unit: nil)).not_to be_valid
  end

end
