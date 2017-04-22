class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.string :name, default: 'n/a'
      t.string :number, default: 'n/a'
      t.string :location, default: 'n/a'
      t.string :major, default: 'n/a'
      t.string :lecture_number, default: 'n/a'
      t.string :lecture_seperation, default: 'n/a'
      t.string :study_date, default: 'n/a'
      t.string :year, default: 'n/a'
      t.string :semester, default: 'n/a'
      t.string :point, default: 'n/a'
      t.string :campus, default: '1'
      t.string :department, default: 'n/a'

      t.string :professor_name, default: 'n/a'

      t.timestamps
    end
  end
end
