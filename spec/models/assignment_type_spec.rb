require 'rails_helper'

RSpec.describe AssignmentType, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:assignment_type)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:assignment_type, name: nil)).not_to be_valid
  end

end
