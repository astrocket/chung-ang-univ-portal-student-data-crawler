class CreateJoinTableCourseHakboo < ActiveRecord::Migration[5.0]
  def change
    create_join_table :courses, :hakboos do |t|
      # t.index [:course_id, :hakboo_id]
      t.index [:hakboo_id, :course_id]
    end
  end
end
