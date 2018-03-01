class CreateCertifications < ActiveRecord::Migration[5.1]
  def change
    create_table :certifications do |t|
      t.references :employee, foreign_key: true
      t.references :certification_type, foreign_key: true
      t.string :certification_number
      t.date :renewed_at
      t.date :expires_at
      t.integer :updated_by

      t.timestamps
    end

    add_foreign_key :certifications, :employees, column: :updated_by
  end
end
