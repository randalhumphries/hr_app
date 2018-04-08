FactoryBot.define do
  factory :relationship_type do
    name { Faker::Lorem.words(1) }
  end
end
