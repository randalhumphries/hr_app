FactoryBot.define do
  factory :benefit do
    employee
    benefit_type
    eligible_at { Date.today }
    notified_at { Date.today }
    association :updated_by, factory: :employee
    notes       { Faker::Lorem.paragraph }
  end
end
