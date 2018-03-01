FactoryBot.define do
  factory :remuneration do
    remuneration_type
    association :updated_by, factory: :employee
    pay_period_salary { Faker::Number.decimal(2) }
    annual_salary     { Faker::Number.decimal(2) }
  end
end
