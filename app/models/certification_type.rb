class CertificationType < ApplicationRecord
  validates :name, :effective_interval, :effective_interval_unit, presence: true
end
