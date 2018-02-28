class CertificationType < ApplicationRecord
  validates :effective_interval, :effective_interval_unit, presence: true
end
