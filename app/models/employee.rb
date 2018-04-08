class Employee < ApplicationRecord
  validates :temp_hire_at, presence: true
  validate  :hire_date_valid?

  before_validation :create_temp_hire_date

  belongs_to :person
  has_many :benefits

  private

    def hire_date_valid?
      if temp_hire_at.present? && temp_hire_at > Date.today
        errors.add(:temp_hire_at, "can't be in the future")
      end
    end

    def create_temp_hire_date
      if full_time_hire_at.present? && temp_hire_at.present? == false
        self.temp_hire_at = full_time_hire_at
      end
    end
end
