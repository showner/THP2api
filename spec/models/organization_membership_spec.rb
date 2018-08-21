# == Schema Information
#
# Table name: organization_memberships
#
#  id              :uuid             not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  member_id       :uuid
#  organization_id :uuid
#
# Indexes
#
#  index_organization_memberships_on_member_id        (member_id)
#  index_organization_memberships_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => users.id)
#  fk_rails_...  (organization_id => organizations.id)
#

require 'rails_helper'

RSpec.describe OrganizationMembership, type: :model do
  describe '#DbColumns' do
    context ':id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end
    context ':created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end
    context ':updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end
    context ':member_id' do
      it { is_expected.to have_db_column(:member_id).of_type(:uuid) }
    end
    context ':organization_id' do
      it { is_expected.to have_db_column(:organization_id).of_type(:uuid) }
    end
  end

  describe '#DbIndex' do
    context ':index_organization_memberships_on_member_id' do
      it { is_expected.to have_db_index(:member_id) }
    end
    context ':index_organization_memberships_on_organization_id' do
      it { is_expected.to have_db_index(:organization_id) }
    end
  end
  describe '#relationship' do
    context 'organization_membership belongs_to organization' do
      it { is_expected.to belong_to(:organization).class_name(:Organization) }
      it { is_expected.to belong_to(:organization).inverse_of(:organization_memberships) }
      it { is_expected.to belong_to(:organization).counter_cache(:members_count) }
    end
    context 'organization_membership belongs_to member' do
      it { is_expected.to belong_to(:member).class_name(:User) }
      it { is_expected.to belong_to(:member).inverse_of(:organization_memberships) }
      it { is_expected.to belong_to(:member).counter_cache(:organizations_count) }
    end
  end

  describe '#Follows' do
    let(:organization_membership) { create(:organization_membership) }
    subject { organization_membership }
    context 'follows organization_membership link through user' do
      it 'organization_membership should eq organization_membership' do
        expect(organization_membership.member.organization_memberships.last).to eq(organization_membership)
      end
    end
    context 'follows organization_membership link through organization' do
      it 'organization_membership should eq organization_membership' do
        expect(organization_membership.organization.organization_memberships.last).to eq(organization_membership)
      end
    end
    context 'marv' do
      it { is_expected.to eq OrganizationMembership.last.member.organization_memberships.last }
    end
  end
end
