FactoryBot.define do
  factory :company_unit do
    name    "Billing"
    association :manager, factory: :employee
  end
end
