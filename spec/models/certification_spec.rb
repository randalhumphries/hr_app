require 'rails_helper'

RSpec.describe Certification, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:certification)).to be_valid
  end

  it 'is not valid without a renewed at date' do
    expect(build(:certification, renewed_at: nil)).not_to be_valid
  end

  it 'is not valid without a expires at date' do
    expect(build(:certification, expires_at: nil)).not_to be_valid
  end

end
