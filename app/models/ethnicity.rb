class Ethnicity < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
