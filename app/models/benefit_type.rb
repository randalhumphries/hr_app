class BenefitType < ApplicationRecord
  validates :name, :eligibility_interval, :eligibility_interval_unit, presence: true
end
