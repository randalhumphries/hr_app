require 'rails_helper'

RSpec.describe EmergencyContact, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:emergency_contact)).to be_valid
  end

  it 'is not valid without a first name' do
    expect(build(:emergency_contact, first_name: nil)).not_to be_valid
  end

  it 'is not valid without a last name' do
    expect(build(:emergency_contact, last_name: nil)).not_to be_valid
  end

  it 'is not valid without a contact' do
    expect(build(:emergency_contact, contact: nil)).not_to be_valid
  end

end
