class AddPersonToCertifications < ActiveRecord::Migration[5.1]
  def change
    remove_column :certifications, :employee_id
    add_reference :certifications, :person, foreign_key: true
  end
end
