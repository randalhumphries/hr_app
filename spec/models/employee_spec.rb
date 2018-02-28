require 'rails_helper'

RSpec.describe Employee, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:employee)).to be_valid
  end

  it 'is valid with a full time hire date instead of a temp hire date' do
    expect(build(:employee, temp_hire_at: nil, full_time_hire_at: Date.today)).to be_valid
  end

  it 'is not valid without a temp hire date' do
    expect(build(:employee, temp_hire_at: nil)).not_to be_valid
  end

  it 'is not valid with a temp hire date in the future' do
    tomorrow_date = Date.today + 1
    expect(build(:employee, temp_hire_at: tomorrow_date)).not_to be_valid
  end

end
