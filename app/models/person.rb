class Person < ApplicationRecord
  validates :first_name, :last_name, :date_of_birth, presence: true
end
