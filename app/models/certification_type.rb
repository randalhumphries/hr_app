class CertificationType < ApplicationRecord
  validates :name, :effective_interval, :effective_interval_unit, presence: true
  validates :name, uniqueness: true
end
