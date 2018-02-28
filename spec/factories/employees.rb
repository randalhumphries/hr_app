FactoryBot.define do
  factory :employee do
    active            true
    temp_hire_at      { Date.today }
    full_time_hire_at nil
    person
  end
end
