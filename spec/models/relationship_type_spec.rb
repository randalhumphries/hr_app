require 'rails_helper'

RSpec.describe RelationshipType, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:relationship_type)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:relationship_type, name: nil)).not_to be_valid
  end

end
