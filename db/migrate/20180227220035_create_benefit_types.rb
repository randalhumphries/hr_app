class CreateBenefitTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :benefit_types do |t|
      t.string :name
      t.integer :eligibility_interval
      t.string :eligibility_interval_unit

      t.timestamps
    end
  end
end
