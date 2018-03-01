require 'rails_helper'

RSpec.describe Contact, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:contact)).to be_valid
  end

  it 'is not valid without a contact' do
    expect(build(:contact, contact: nil)).not_to be_valid
  end

end
