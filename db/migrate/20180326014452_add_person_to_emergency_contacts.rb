class AddPersonToEmergencyContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :emergency_contacts, :person, foreign_key: true
  end
end
