FactoryBot.define do
  factory :company_unit do
    name    "Billing"
    company
    association :manager, factory: :employee
  end
end
