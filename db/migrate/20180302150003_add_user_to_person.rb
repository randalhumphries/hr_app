class AddUserToPerson < ActiveRecord::Migration[5.1]
  def change
    add_reference :people, :user, foreign_key: true
  end
end
