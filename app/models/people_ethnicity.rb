class PeopleEthnicity < ApplicationRecord
  belongs_to :person
  belongs_to :ethnicity
end
