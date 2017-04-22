class CreateProfessors < ActiveRecord::Migration[5.0]
  def change
    create_table :professors do |t|
      t.string :number, default: 'n/a'
      t.string :name, default: 'n/a'
      t.string :email, default: 'n/a'
      t.string :tel, default: 'n/a'
      t.string :phone, default: 'n/a'
      t.string :group, default: 'n/a'
      t.string :college, default: 'n/a'
      t.string :subject, default: 'n/a'
      t.string :career, default: 'n/a'
      t.string :site, default: 'n/a'
      t.string :image, default: 'n/a'

      t.timestamps
    end
  end
end
