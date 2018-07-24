class UuidAsUsersPrimaryKey < ActiveRecord::Migration[5.2]
  def up
    add_column :users, :uuid, :uuid, default: "uuid_generate_v4()", null: false
    change_table :users, bulk: true do |t|
      t.remove :id
    end
    rename_column :users, :uuid, :id
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
    add_index :users, :created_at
  end

  def down
    change_table :users, bulk: true do |t|
      t.integer :id
    end
    rename_column :users, :id, :uuid
    remove_index :users, :created_at
  end
end
