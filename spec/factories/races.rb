FactoryBot.define do
  factory :race do
    name  { Faker::Lorem.words(1) }
  end
end
