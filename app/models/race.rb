class Race < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
