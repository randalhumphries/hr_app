class Assignment < ApplicationRecord
  validates :assigned_at, presence: true
  
  belongs_to :assignment_type
  belongs_to :company_unit
end
