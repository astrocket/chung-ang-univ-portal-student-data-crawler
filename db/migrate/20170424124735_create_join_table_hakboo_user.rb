class CreateJoinTableHakbooUser < ActiveRecord::Migration[5.0]
  def change
    create_join_table :hakboos, :users do |t|
      # t.index [:hakboo_id, :user_id]
      t.index [:user_id, :hakboo_id]
    end
  end
end
