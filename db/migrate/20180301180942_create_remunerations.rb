class CreateRemunerations < ActiveRecord::Migration[5.1]
  def change
    create_table :remunerations do |t|
      t.references :employee, foreign_key: true
      t.references :remuneration_type, foreign_key: true
      t.integer :updated_by
      t.decimal :pay_period_salary
      t.decimal :annual_salary

      t.timestamps
    end

    add_foreign_key :remunerations, :employees, column: :updated_by
  end
end
