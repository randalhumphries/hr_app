require 'rails_helper'

RSpec.describe Demographic, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:demographic)).to be_valid
  end

end
