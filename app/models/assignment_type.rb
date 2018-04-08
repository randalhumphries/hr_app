class AssignmentType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
