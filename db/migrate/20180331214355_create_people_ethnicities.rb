class CreatePeopleEthnicities < ActiveRecord::Migration[5.1]
  def change
    create_table :people_ethnicities do |t|
      t.references :person, foreign_key: true
      t.references :ethnicity, foreign_key: true

      t.timestamps
    end
  end
end
