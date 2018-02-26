FactoryBot.define do
  factory :person do
    first_name { Faker::Name.first_name }
    middle_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    prefix { Faker::Name.prefix }
    suffix { Faker::Name.suffix }
  end
end
