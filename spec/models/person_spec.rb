require 'rails_helper'

RSpec.describe Person, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:person)).to be_valid
  end

  it 'is not valid without a first name' do
    expect(build(:person, first_name: nil)).not_to be_valid
  end

  it 'is not valid without a last name' do
    expect(build(:person, last_name: nil)).not_to be_valid
  end

end
