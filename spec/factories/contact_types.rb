FactoryBot.define do
  factory :contact_type do
    name  { Faker::Lorem.words(1) }
  end
end
