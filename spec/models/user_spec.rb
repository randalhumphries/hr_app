require 'rails_helper'

RSpec.describe User, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:user)).to be_valid
  end

  it 'is not valid without an email' do
    expect(build(:user, email: nil)).not_to be_valid
  end

end
