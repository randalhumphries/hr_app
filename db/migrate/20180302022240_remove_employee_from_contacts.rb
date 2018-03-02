class RemoveEmployeeFromContacts < ActiveRecord::Migration[5.1]
  def change
    remove_column :contacts, :employee_id
  end
end
