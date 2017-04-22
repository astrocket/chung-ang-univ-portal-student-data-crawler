class CreateSugangs < ActiveRecord::Migration[5.0]
  def change
    create_table :sugangs do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :course, foreign_key: true

      t.timestamps
    end
  end
end
