# == Schema Information
#
# Table name: invitations
#
#  id                :uuid             not null, primary key
#  destination_email :string
#  interest_type     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  emitter_id        :uuid
#  interest_id       :uuid
#  invitee_id        :uuid
#
# Indexes
#
#  index_invitations_on_emitter_id                     (emitter_id)
#  index_invitations_on_interest_type_and_interest_id  (interest_type,interest_id)
#  index_invitations_on_invitee_id                     (invitee_id)
#
# Foreign Keys
#
#  fk_rails_...  (emitter_id => users.id)
#  fk_rails_...  (invitee_id => users.id)
#

require 'rails_helper'

RSpec.describe Invitation, type: :model do
  describe '#validator' do
    context 'when factory is valid' do
      subject(:invitation) { create(:invitation, :with_emitter, :with_email) }

      # it { binding.pry }
      it { is_expected.to be_valid }
      it { expect{ invitation }.to change(Invitation, :count).by(1) }
    end
  end

  describe '#scope' do
    context 'with :default_scope' do
      it { expect(Invitation.all.default_scoped.to_sql).to eq Invitation.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context 'with :id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end

    context 'with :destination_email' do
      it { is_expected.to have_db_column(:destination_email).of_type(:string) }
    end

    context 'with :interest_type' do
      it { is_expected.to have_db_column(:interest_type).of_type(:string) }
    end

    context 'with :created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end

    context 'with :updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end

    context 'with :emitter_id' do
      it { is_expected.to have_db_column(:emitter_id).of_type(:uuid) }
    end

    context 'with :interest_id' do
      it { is_expected.to have_db_column(:interest_id).of_type(:uuid) }
    end

    context 'with :invitee_id' do
      it { is_expected.to have_db_column(:invitee_id).of_type(:uuid) }
    end
  end

  describe '#DbIndex' do
    context 'with :index_invitations_on_emitter_id' do
      it { is_expected.to have_db_index(:emitter_id) }
    end

    context 'with :index_invitations_on_interest_type_and_interest_id' do
      it { is_expected.to have_db_index(%i[interest_type interest_id]) }
      # it { is_expected.to have_db_index(:interest_id) }
    end

    context 'with :index_invitations_on_invitee_id' do
      it { is_expected.to have_db_index(:invitee_id) }
    end
  end

  describe '#relationship' do
    subject(:sub_invitation) { create(:invitation, :with_invitee, emitter: user) }

    let!(:user) { create(:user) }
    # let!(:course) { create(:course, creator: user) }
    # let(:invitation) { create(:invitation) }

    context 'with invitation belongs_to user(invitee)' do
      it { is_expected.to belong_to(:invitee).class_name(:User) }
      it { is_expected.to belong_to(:invitee).inverse_of(:received_invitations) }
      it { is_expected.to belong_to(:invitee).counter_cache(:received_invitations_count) }
    end

    context 'with invitation belongs_to user(emitter)' do
      it { is_expected.to belong_to(:emitter).class_name(:User) }
      it { is_expected.to belong_to(:emitter).inverse_of(:emitted_invitations) }
      it { is_expected.to belong_to(:emitter).counter_cache(:emitted_invitations_count) }
    end

    context 'with invitation belongs_to course' do
      it { is_expected.to belong_to(:interest) }
    end

    context 'when increment created_invitations_count by 1' do
      it { expect{ sub_invitation }.to change(user, :emitted_invitations_count).by(1) }
    end

    xcontext 'when increment invitations_count by 1' do
      it { expect{ sub_invitation }.to change{ Organization.last.invitations_count }.by(1) }
    end
  end

  describe "#Follows with invitee, emitter and course interest" do
    subject(:invitation) { create(:invitation, :with_emitter, :with_invitee, interest: course) }

    let(:course) { create(:course) }

    context 'when invitation link through emitter' do
      it 'invitation should eq invitation' do
        expect(invitation.emitter.emitted_invitations.last).to eq(invitation)
      end
    end

    context 'when invitation link through invitee' do
      it 'invitation should eq invitation' do
        expect(invitation.invitee.received_invitations.last).to eq(invitation)
      end
    end

    context 'when invitation link through interest' do
      it 'invitation should eq invitation' do
        expect(invitation.interest.invitations.last).to eq(invitation)
      end
    end
  end

  describe "#Follows with invitee, emitter and course_session interest" do
    subject(:invitation) { create(:invitation, :with_emitter, :with_invitee, interest: course_session) }

    let(:course_session) { create(:course_session) }

    context 'when invitation link through emitter' do
      it 'invitation should eq invitation' do
        expect(invitation.emitter.emitted_invitations.last).to eq(invitation)
      end
    end

    context 'when invitation link through invitee' do
      it 'invitation should eq invitation' do
        expect(invitation.invitee.received_invitations.last).to eq(invitation)
      end
    end

    context 'when invitation link through interest' do
      it 'invitation should eq invitation' do
        expect(invitation.interest.invitations.last).to eq(invitation)
      end
    end
  end

  describe "#Follows with invitee, emitter and organization interest" do
    subject(:invitation) { create(:invitation, :with_emitter, :with_invitee, interest: organization) }

    let(:organization) { create(:organization) }

    context 'when invitation link through emitter' do
      it 'invitation should eq invitation' do
        expect(invitation.emitter.emitted_invitations.last).to eq(invitation)
      end
    end

    context 'when invitation link through invitee' do
      it 'invitation should eq invitation' do
        expect(invitation.invitee.received_invitations.last).to eq(invitation)
      end
    end

    context 'when invitation link through interest' do
      it 'invitation should eq invitation' do
        expect(invitation.interest.invitations.last).to eq(invitation)
      end
    end
  end

  describe "#Follows with invitee, emitter" do
    subject(:invitation) { create(:invitation, :with_emitter, :with_invitee) }

    context 'when invitation link through emitter' do
      it 'invitation should eq invitation' do
        expect(invitation.emitter.emitted_invitations.last).to eq(invitation)
      end
    end

    context 'when invitation link through invitee' do
      it 'invitation should eq invitation' do
        expect(invitation.invitee.received_invitations.last).to eq(invitation)
      end
    end
  end

  describe "#Serialization" do
    subject(:serializer) { InvitationSerializer.new(invitation) }

    let(:invitation) { create(:invitation, :with_emitter, :with_invitee) }

    it { is_expected.to respond_to(:serializable_hash) }
    context 'with invitation serializer' do
      it { expect(serializer.serializable_hash).to have_key(:id) }
      it { expect(serializer.serializable_hash).to have_key(:destination_email) }
      it { expect(serializer.serializable_hash).to have_key(:interest_type) }
      it { expect(serializer.serializable_hash).to have_key(:created_at) }
      it { expect(serializer.serializable_hash).to have_key(:updated_at) }
      it { expect(serializer.serializable_hash).to have_key(:emitter_id) }
      it { expect(serializer.serializable_hash).to have_key(:interest_id) }
      it { expect(serializer.serializable_hash).to have_key(:invitee_id) }
    end
  end
end
