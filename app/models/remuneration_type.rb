class RemunerationType < ApplicationRecord
  validates :name, :pay_period_hours, :annual_pay_periods, presence: true
end
