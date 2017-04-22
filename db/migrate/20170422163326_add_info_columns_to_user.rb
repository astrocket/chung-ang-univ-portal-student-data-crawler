class AddInfoColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :gpa, :string, default: 'n/a'
    add_column :users, :birth, :string, default: 'n/a'
    add_column :users, :english_name, :string, default: 'n/a'
    add_column :users, :chinese_name, :string, default: 'n/a'
    add_column :users, :gender, :string, default: 'n/a'
    add_column :users, :department_name, :string, default: 'n/a'
    add_column :users, :major_name, :string, default: 'n/a'
    add_column :users, :recent_grade, :string, default: 'n/a'
    add_column :users, :recent_year, :string, default: 'n/a'
    add_column :users, :recent_semester, :string, default: 'n/a'
    add_column :users, :campus, :string, default: 'n/a'
  end
end
