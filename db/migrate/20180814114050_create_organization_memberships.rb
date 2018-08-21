class CreateOrganizationMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_memberships, id: :uuid do |t|
      t.references :organization, type: :uuid, foreign_key: { to_table: :organizations }, index: true
      t.references :member, type: :uuid, foreign_key: { to_table: :users }, index: true

      t.timestamps
    end
    add_column :users, :organizations_count, :integer, default: 0
    add_column :organizations, :members_count, :integer, default: 0
  end
end
