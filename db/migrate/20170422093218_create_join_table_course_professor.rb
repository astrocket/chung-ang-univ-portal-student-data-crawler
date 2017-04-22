class CreateJoinTableCourseProfessor < ActiveRecord::Migration[5.0]
  def change
    create_join_table :courses, :professors do |t|
      # t.index [:course_id, :professor_id]
      t.index [:professor_id, :course_id]
    end
  end
end
