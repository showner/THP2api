class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations, id: :uuid do |t|
      t.string :name, limit: 50, null: false
      t.text :website, limit: 2000
      t.integer :created_sessions_count, default: 0
      t.references :creator, type: :uuid, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
    add_column :users, :created_organizations_count, :integer, default: 0
    add_reference :course_sessions, :creator, type: :uuid, foreign_key: { to_table: :organizations }, index: true
  end
end
