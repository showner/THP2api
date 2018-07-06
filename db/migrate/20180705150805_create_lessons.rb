class CreateLessons < ActiveRecord::Migration[5.2]
  def change
    create_table :lessons, id: :uuid do |t|
      t.string :title, limit: 50, null: false
      t.text :description, limit: 300

      t.timestamps
    end
  end
end
