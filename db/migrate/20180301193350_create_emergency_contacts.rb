class CreateEmergencyContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :emergency_contacts do |t|
      t.references :employee, foreign_key: true
      t.references :relationship_type, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.references :contact_type, foreign_key: true
      t.string :contact

      t.timestamps
    end
  end
end
