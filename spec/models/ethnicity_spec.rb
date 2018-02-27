require 'rails_helper'

RSpec.describe Ethnicity, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:ethnicity)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:ethnicity, name: nil)).not_to be_valid
  end

end
