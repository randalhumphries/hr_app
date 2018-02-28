class CreateEmployees < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.boolean :active, default: true
      t.date :temp_hire_at
      t.date :full_time_hire_at
      t.references :person, foreign_key: true

      t.timestamps
    end
  end
end
