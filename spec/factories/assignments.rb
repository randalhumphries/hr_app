FactoryBot.define do
  factory :assignment do
    assignment_type
    employee
    assigned_at { Date.today }
    association :assigned_by, factory: :employee
    company_unit
  end
end
