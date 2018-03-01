class Contact < ApplicationRecord
  validates :contact, presence: true
  
  belongs_to :employee
  belongs_to :contact_type
end
