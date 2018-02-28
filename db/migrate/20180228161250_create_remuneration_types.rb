class CreateRemunerationTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :remuneration_types do |t|
      t.string :name
      t.integer :pay_period_hours
      t.integer :annual_pay_periods

      t.timestamps
    end
  end
end
