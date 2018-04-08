FactoryBot.define do
  factory :certification do
    person
    certification_type
    certification_number  "MyString"
    renewed_at            { Date.today }
    expires_at            { Date.today }
    association :updated_by, factory: :employee
  end
end
