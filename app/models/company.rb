class Company < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :company_units
  has_many :people
  has_many :users, dependent: :destroy
  has_one :employee, through: :people
end
