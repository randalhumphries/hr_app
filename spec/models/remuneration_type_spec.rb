require 'rails_helper'

RSpec.describe RemunerationType, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:remuneration_type)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:remuneration_type, name: nil)).not_to be_valid
  end

  it 'is not valid without pay period hours' do
    expect(build(:remuneration_type, pay_period_hours: nil)).not_to be_valid
  end

  it 'is not valid without annual pay periods' do
    expect(build(:remuneration_type, annual_pay_periods: nil)).not_to be_valid
  end

end
