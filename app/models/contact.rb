class Contact < ApplicationRecord
  validates :contact, presence: true
  
  belongs_to :person
  belongs_to :contact_type
end
