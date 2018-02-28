require 'rails_helper'

RSpec.describe Race, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:race)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:race, name: nil)).not_to be_valid
  end

end
