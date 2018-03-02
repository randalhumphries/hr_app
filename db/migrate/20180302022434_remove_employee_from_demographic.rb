class RemoveEmployeeFromDemographic < ActiveRecord::Migration[5.1]
  def change
    remove_column :demographics, :employee_id
  end
end
