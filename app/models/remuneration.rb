class Remuneration < ApplicationRecord
  validates :pay_period_salary, :annual_salary, presence: true
  
  belongs_to :remuneration_type
end
