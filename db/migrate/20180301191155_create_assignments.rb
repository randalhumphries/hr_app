class CreateAssignments < ActiveRecord::Migration[5.1]
  def change
    create_table :assignments do |t|
      t.references :assignment_type, foreign_key: true
      t.integer :employee
      t.date :assigned_at
      t.integer :assigned_by
      t.references :company_unit, foreign_key: true

      t.timestamps
    end
  
    add_foreign_key :assignments, :employees, column: :assigned_by
  end
end
