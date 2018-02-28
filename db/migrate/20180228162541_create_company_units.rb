class CreateCompanyUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :company_units do |t|
      t.string :name
      t.integer :manager

      t.timestamps
    end

    add_foreign_key :company_units, :employees, column: :manager
  end
end
