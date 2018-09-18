class CreateRessources < ActiveRecord::Migration[5.2]
  def change
    create_table :ressources, id: :uuid do |t|
      t.string :label, limit: 50
      t.text :uri, limit: 2000, null: false

      t.timestamps

      t.index :label
      t.index :uri, unique: true
    end
  end
end
