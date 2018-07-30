class UuidAsUsersPrimaryKey < ActiveRecord::Migration[5.2]
  def up
    change_table :users, bulk: true do |t|
      t.remove :id
      t.primary_key :id, :uuid, default: 'gen_random_uuid()'
    end
    add_index :users, :created_at
  end

  def down
    change_table :users, bulk: true do |t|
      t.remove :id
      t.primary_key :id
    end
    remove_index :users, :created_at
  end
end
