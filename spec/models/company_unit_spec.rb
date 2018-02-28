require 'rails_helper'

RSpec.describe CompanyUnit, type: :model do
  
  it 'is valid with valid attributes' do
    expect(build(:company_unit)).to be_valid
  end
  
  it 'is not valid without a name' do
    expect(build(:company_unit, name: nil)).not_to be_valid
  end

end
