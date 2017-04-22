class CreateMistakes < ActiveRecord::Migration[5.0]
  def change
    create_table :mistakes do |t|
      t.text :content

      t.timestamps
    end
  end
end
