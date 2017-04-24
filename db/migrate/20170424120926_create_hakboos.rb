class CreateHakboos < ActiveRecord::Migration[5.0]
  def change
    create_table :hakboos do |t|
      t.string :name, default: 'n/a'

      t.timestamps
    end
  end
end
