require 'rails_helper'

RSpec.describe Benefit, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:benefit)).to be_valid
  end

  it 'is not valid without an eligible at date' do
    expect(build(:benefit, eligible_at: nil)).not_to be_valid
  end

end
