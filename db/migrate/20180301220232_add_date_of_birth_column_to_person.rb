class AddDateOfBirthColumnToPerson < ActiveRecord::Migration[5.1]
  def change
    add_column :people, :date_of_birth, :date
  end
end
