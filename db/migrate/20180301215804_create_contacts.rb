class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.references :employee, foreign_key: true
      t.references :contact_type, foreign_key: true
      t.string :contact

      t.timestamps
    end
  end
end
