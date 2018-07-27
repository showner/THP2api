class AddUserToLessons < ActiveRecord::Migration[5.2]
  def change
    add_reference :lessons, :creator, type: :uuid, foreign_key: { to_table: :users }, index: true
  end
end
