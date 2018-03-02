class AddPersonToDemographics < ActiveRecord::Migration[5.1]
  def change
    add_reference :demographics, :person, foreign_key: true
  end
end
