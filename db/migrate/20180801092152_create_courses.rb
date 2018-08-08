class CreateCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses, id: :uuid do |t|
      t.string :title, limit: 50, null: false
      t.text :description, limit: 300, null: false
      t.integer :lessons_count, default: 0
      t.references :creator, type: :uuid, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
    add_column :users, :created_courses_count, :integer, default: 0
    add_reference :lessons, :course, type: :uuid, foreign_key: true, index: true
  end
end
