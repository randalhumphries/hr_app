FactoryBot.define do
  factory :emergency_contact do
    person
    relationship_type
    first_name    { Faker::Name.first_name }
    last_name     { Faker::Name.last_name }
    contact_type
    contact       { Faker::Internet.email }
  end
end
