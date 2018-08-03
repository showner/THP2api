class CreateCourseSessions < ActiveRecord::Migration[5.2]
  def change
    create_table :course_sessions, id: :uuid do |t|
      t.string :name, limit: 50
      t.datetime :starting_date, null: false
      t.datetime :ending_date
      t.integer :student_max, null: false
      t.integer :student_min, default: 2, null: false
      t.references :course, type: :uuid, foreign_key: true, index: true

      t.timestamps
    end
    # Two way
    # change_table :courses do |t|
    #   t.integer :courses_count, default: 0
    # end
    add_column :courses, :sessions_count, :integer, default: 0
    # add column integer
    # t.integer :student_registrations_count, default: 0
    # add_reference :course_sessions, :organization, type: :uuid, foreign_key: true, index: true
    # add_reference :course_sessions, :organization_constrains, type: :uuid, foreign_key: true, index: true
  end
end
