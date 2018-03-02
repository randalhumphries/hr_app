class RemoveEmployeeFromEmergencyContact < ActiveRecord::Migration[5.1]
  def change
    remove_column :emergency_contacts, :employee_id
  end
end
