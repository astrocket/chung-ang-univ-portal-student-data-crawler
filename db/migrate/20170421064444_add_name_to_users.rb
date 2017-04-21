class AddNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :student, :string
    add_column :users, :name, :string
    add_column :users, :status, :boolean, default: false
  end
end
