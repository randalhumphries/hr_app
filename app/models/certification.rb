class Certification < ApplicationRecord
  validates :renewed_at, :expires_at, presence: true
  
  belongs_to :person
  belongs_to :certification_type
end
