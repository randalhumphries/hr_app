class AddCompanyToCompanyUnits < ActiveRecord::Migration[5.1]
  def change
    add_reference :company_units, :company, foreign_key: true
  end
end
