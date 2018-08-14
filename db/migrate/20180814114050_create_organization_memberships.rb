class CreateOrganizationMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :organization_memberships, id: :uuid do |t|
      t.references :organization, type: :uuid, foreign_key: { to_table: :organizations }, index: true
      t.references :member, type: :uuid, foreign_key: { to_table: :users }, index: true
      t.integer :organizations_count, default: 0
      t.integer :members_count, default: 0

      t.timestamps
    end
  end
end
