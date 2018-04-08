class Person < ApplicationRecord
  validates :first_name, :last_name, :date_of_birth, presence: true

  belongs_to :company
  belongs_to :user, optional: true
  has_one :employee, dependent: :destroy
  has_one :address, dependent: :destroy
  has_many :contacts, dependent: :destroy
  has_many :people_race, dependent: :destroy
  has_many :races, through: :people_race
  has_many :people_ethnicity, dependent: :destroy
  has_many :ethnicities, through: :people_ethnicity
  has_many :emergency_contacts, dependent: :destroy
  has_many :certifications, dependent: :destroy
end
