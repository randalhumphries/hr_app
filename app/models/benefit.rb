class Benefit < ApplicationRecord
  validates :eligible_at, presence: true
  
  belongs_to :employee
  belongs_to :benefit_type
end
