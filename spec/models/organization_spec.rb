# == Schema Information
#
# Table name: organizations
#
#  id            :uuid             not null, primary key
#  members_count :integer          default(0)
#  name          :string(50)       not null
#  website       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :uuid
#
# Indexes
#
#  index_organizations_on_creator_id  (creator_id)
#  index_organizations_on_name        (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

require 'rails_helper'

RSpec.describe Organization, type: :model do
  describe '#validator' do
    subject { create(:organization) }
    context 'factory is valid' do
      it { is_expected.to be_valid }
      it { expect{ subject }.to change{ Organization.count }.by(1) }
    end

    context ':name' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
      it { is_expected.to validate_length_of(:name).is_at_most(50) }
    end

    context ':website' do
      it { is_expected.to validate_uniqueness_of(:website).case_insensitive.allow_nil }
      it { is_expected.to validate_length_of(:website).is_at_most(2000) }
    end
  end

  describe '#scope' do
    context ':default_scope' do
      it { expect(Organization.all.default_scoped.to_sql).to eq Organization.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context ':id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end
    context ':members_count' do
      it { is_expected.to have_db_column(:members_count).of_type(:integer) }
      it { is_expected.to have_db_column(:members_count).with_options(default: 0) }
    end
    context ':name' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
      it { is_expected.to have_db_column(:name).with_options(limit: 50, null: false) }
    end
    context ':website' do
      it { is_expected.to have_db_column(:website).of_type(:text) }
    end
    context ':created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end
    context ':updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end
    context ':creator_id' do
      it { is_expected.to have_db_column(:creator_id).of_type(:uuid) }
    end
  end

  describe '#DbIndex' do
    context ':index_organizations_on_creator_id' do
      it { is_expected.to have_db_index(:creator_id) }
    end

    context ':index_organizations_on_name' do
      it { is_expected.to have_db_index(:name).unique(true) }
    end
  end

  describe '#relationship' do
    let!(:user) { create(:user) }
    let(:organization) { create(:organization) }
    subject { create(:organization, creator: user) }
    context 'organization belongs_to user' do
      it { is_expected.to belong_to(:creator).class_name(:User) }
      it { is_expected.to belong_to(:creator).inverse_of(:created_organizations) }
      it { is_expected.to belong_to(:creator).counter_cache(:created_organizations_count) }
    end
    context 'increment created_courses_count by 1' do
      it { expect{ subject }.to change{ User.last.created_organizations_count }.by(1) }
    end
    context 'organization has_many organization_memberships' do
      it { is_expected.to have_many(:organization_memberships).with_foreign_key(:organization_id) }
      it { is_expected.to have_many(:organization_memberships).dependent(:destroy) }
      it { is_expected.to have_many(:organization_memberships).inverse_of(:organization) }
    end
    context 'organization has_many members through organization_memberships' do
      it { is_expected.to have_many(:members).through(:organization_memberships) }
    end
  end

  describe '#Follows' do
    let(:organization) { create(:organization) }
    subject { organization }
    context 'follows organization link through user' do
      it 'organization should eq organization' do
        expect(organization.creator.created_organizations.last).to eq(organization)
      end
    end
  end

  describe "#Serialization" do
    let(:organization) { create(:organization) }
    subject(:serializer) { OrganizationSerializer.new(organization) }
    it { is_expected.to respond_to(:serializable_hash) }
    context 'organization serializer' do
      it { expect(subject.serializable_hash).to have_key(:id) }
      it { expect(subject.serializable_hash).to have_key(:name) }
      it { expect(subject.serializable_hash).to have_key(:website) }
      it { expect(subject.serializable_hash).to have_key(:created_at) }
      it { expect(subject.serializable_hash).to have_key(:updated_at) }
      it { expect(subject.serializable_hash).to have_key(:creator_id) }
      it { expect(subject.serializable_hash).to have_key(:members_count) }
      it { expect(subject.serializable_hash).to have_key(:members) }
    end
  end
end
