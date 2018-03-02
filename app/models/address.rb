class Address < ApplicationRecord
  validates :address_1, :city, :zip, presence: true
  validate :state_present?

  belongs_to :person

  private

    def state_present?
      if state.nil? && country == 'US'
        errors.add(:state, "can't be blank")
      end
    end
end
