class Person < ApplicationRecord
  validates :first_name, :last_name, :date_of_birth, presence: true

  has_one :employee, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :emergency_contacts, dependent: :destroy
  has_one :address, dependent: :destroy
end
