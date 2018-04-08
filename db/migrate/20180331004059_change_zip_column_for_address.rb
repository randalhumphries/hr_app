class ChangeZipColumnForAddress < ActiveRecord::Migration[5.1]
  def change
    change_table :addresses do |t|
      t.change :zip, :string
    end
  end
end
