class EmergencyContact < ApplicationRecord
  validates :first_name, :last_name, :contact, presence: true

  belongs_to :relationship_type
  belongs_to :contact_type
  belongs_to :person
end
