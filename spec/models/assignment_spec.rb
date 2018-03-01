require 'rails_helper'

RSpec.describe Assignment, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:assignment)).to be_valid
  end

  it 'is not valid without a assigned at date' do
    expect(build(:assignment, assigned_at: nil)).not_to be_valid
  end

end
