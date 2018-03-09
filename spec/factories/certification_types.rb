FactoryBot.define do
  factory :certification_type do
    name                    { Faker::Lorem.words(1) }
    effective_interval       1
    effective_interval_unit "year"
  end
end
