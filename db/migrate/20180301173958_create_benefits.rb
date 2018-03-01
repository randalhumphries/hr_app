class CreateBenefits < ActiveRecord::Migration[5.1]
  def change
    create_table :benefits do |t|
      t.references :employee, foreign_key: true
      t.references :benefit_type, foreign_key: true
      t.date :eligible_at
      t.date :notified_at
      t.integer :updated_by
      t.text :notes

      t.timestamps
    end

    add_foreign_key :benefits, :employees, column: :updated_by
  end
end
