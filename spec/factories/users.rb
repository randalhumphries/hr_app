FactoryBot.define do
  factory :user do
    password = Faker::Internet.password

    email                 { Faker::Internet.unique.email }
    password              password
    password_confirmation password
    active                true
    admin                 false
    company

    trait :admin do
      admin true
    end

    trait :active do
      active true
    end

    trait :inactive do
      active false
    end
  end
end
