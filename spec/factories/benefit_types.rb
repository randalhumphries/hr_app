FactoryBot.define do
  factory :benefit_type do
    name                      "401k"
    eligibility_interval      6
    eligibility_interval_unit "months"
  end
end
