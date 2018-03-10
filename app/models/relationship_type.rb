class RelationshipType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
