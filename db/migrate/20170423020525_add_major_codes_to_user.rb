class AddMajorCodesToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :college_name, :string, default: 'n/a'
    add_column :users, :college_code, :string, default: 'n/a'
    add_column :users, :department_code, :string, default: 'n/a'
    add_column :users, :major_code, :string, default: 'n/a'

    add_column :users, :final_gpa, :float, default: 0
    add_column :users, :admission_type, :string, default: 'n/a'
    add_column :users, :tel, :string, default: 'n/a'
    add_column :users, :phone, :string, default: 'n/a'
    add_column :users, :military, :string, default: 'n/a'
    add_column :users, :mail, :string, default: 'n/a'
    add_column :users, :address, :string, default: 'n/a'
    add_column :users, :preschool_type, :string, default: 'n/a'
    add_column :users, :preschool_name, :string, default: 'n/a'

    add_column :users, :parent_name, :string, default: 'n/a'
    add_column :users, :parent_type, :string, default: 'n/a'
    add_column :users, :parent_tel, :string, default: 'n/a'
    add_column :users, :parent_phone, :string, default: 'n/a'
    add_column :users, :parent_address, :string, default: 'n/a'

  end
end
