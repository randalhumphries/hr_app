class Person < ApplicationRecord
  validates :first_name, :last_name, :date_of_birth, presence: true

  has_one :employee
  has_many :contacts
end
