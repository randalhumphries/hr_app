FactoryBot.define do
  factory :address do
    person
    address_1 { Faker::Address.street_address }
    address_2 { Faker::Address.secondary_address }
    city      { Faker::Address.city }
    state     { Faker::Address.state_abbr }
    zip       { Faker::Address.zip }
    country   { Faker::Address.country_code }
  end
end
