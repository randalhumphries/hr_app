class CreateDemographics < ActiveRecord::Migration[5.1]
  def change
    create_table :demographics do |t|
      t.references :employee, foreign_key: true
      t.references :race, foreign_key: true
      t.references :ethnicity, foreign_key: true
      t.references :contact, foreign_key: true
      t.references :emergency_contact, foreign_key: true

      t.timestamps
    end
  end
end
