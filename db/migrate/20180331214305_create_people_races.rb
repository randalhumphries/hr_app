class CreatePeopleRaces < ActiveRecord::Migration[5.1]
  def change
    create_table :people_races do |t|
      t.references :person, foreign_key: true
      t.references :race, foreign_key: true

      t.timestamps
    end
  end
end
