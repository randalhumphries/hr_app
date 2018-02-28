require 'rails_helper'

RSpec.describe ContactType, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:contact_type)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:contact_type, name: nil)).not_to be_valid
  end

end
