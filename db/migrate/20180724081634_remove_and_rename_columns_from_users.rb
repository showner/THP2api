class RemoveAndRenameColumnsFromUsers < ActiveRecord::Migration[5.2]
  # https://guides.rubyonrails.org/active_record_migrations.html#using-the-change-method
  # https://api.rubyonrails.org/v5.2.0/classes/ActiveRecord/ConnectionAdapters/SchemaStatements.html#method-i-change_table
  def up
    rename_column :users, :name, :username

    change_table :users, bulk: true do |t|
      t.remove :image
      t.remove :nickname
    end
    add_index :users, :username, unique: true
  end

  def down
    rename_column :users, :username, :name

    # remove_index :users, :username
    change_table :users, bulk: true do |t|
      t.string :image
      t.string :nickname
    end
  end
end
