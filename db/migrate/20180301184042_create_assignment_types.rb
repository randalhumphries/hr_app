class CreateAssignmentTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :assignment_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
