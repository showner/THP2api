class AddLessonCreatedCount < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :created_lessons_count, :integer, default: 0
  end
end
