class CreateJoinTableHakbooProfessor < ActiveRecord::Migration[5.0]
  def change
    create_join_table :hakboos, :professors do |t|
      # t.index [:hakboo_id, :professor_id]
      # t.index [:professor_id, :hakboo_id]
    end
  end
end
