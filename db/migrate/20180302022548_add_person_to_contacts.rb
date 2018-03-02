class AddPersonToContacts < ActiveRecord::Migration[5.1]
  def change
    add_reference :contacts, :person, foreign_key: true
  end
end
