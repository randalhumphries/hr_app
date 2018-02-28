require 'rails_helper'

RSpec.describe CertificationType, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:certification_type)).to be_valid
  end

  it 'is not valid without a name' do
    expect(build(:certification_type, name: nil)).not_to be_valid
  end

  it 'is not valid without an effective interval' do
    expect(build(:certification_type, effective_interval: nil)).not_to be_valid
  end

  it 'is not valid without an effective interval unit' do
    expect(build(:certification_type, effective_interval_unit: nil)).not_to be_valid
  end
  
end
