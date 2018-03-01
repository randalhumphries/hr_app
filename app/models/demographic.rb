class Demographic < ApplicationRecord
  belongs_to :employee
  belongs_to :race
  belongs_to :ethnicity
  belongs_to :contact
  belongs_to :emergency_contact
end
