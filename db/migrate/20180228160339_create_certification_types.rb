class CreateCertificationTypes < ActiveRecord::Migration[5.1]
  def change
    create_table :certification_types do |t|
      t.string :name
      t.integer :effective_interval
      t.string :effective_interval_unit

      t.timestamps
    end
  end
end
