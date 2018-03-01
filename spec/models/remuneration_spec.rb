require 'rails_helper'

RSpec.describe Remuneration, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:remuneration)).to be_valid
  end

  it 'is not valid without a pay period salary' do
    expect(build(:remuneration, pay_period_salary: nil)).not_to be_valid
  end

  it 'is not valid without an annual salary' do
    expect(build(:remuneration, annual_salary: nil)).not_to be_valid
  end

end
