class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :student, :string
  end
end
