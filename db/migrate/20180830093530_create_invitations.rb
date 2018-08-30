class CreateInvitations < ActiveRecord::Migration[5.2]
  def change
    create_table :invitations, id: :uuid do |t|
      t.string :destination_email, null: false
      # sender_name
      # sender_email
      t.references :interest, type: :uuid, polymorphic: true
      t.references :invitee, type: :uuid, foreign_key: { to_table: :users }, index: true
      t.references :emitter, type: :uuid, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end

    change_table :users, bulk: true do
      add_column :users, :emitted_invitations_count, :integer, default: 0
      add_column :users, :received_invitations_count, :integer, default: 0
    end
  end
end
