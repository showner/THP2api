# == Schema Information
#
# Table name: users
#
#  id                          :uuid             not null, primary key
#  allow_password_change       :boolean          default(FALSE)
#  confirmation_sent_at        :datetime
#  confirmation_token          :string
#  confirmed_at                :datetime
#  created_courses_count       :integer          default(0)
#  created_lessons_count       :integer          default(0)
#  created_organizations_count :integer          default(0)
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string
#  email                       :string
#  emitted_invitations_count   :integer          default(0)
#  encrypted_password          :string           default(""), not null
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string
#  organizations_count         :integer          default(0)
#  provider                    :string           default("email"), not null
#  received_invitations_count  :integer          default(0)
#  remember_created_at         :datetime
#  reset_password_sent_at      :datetime
#  reset_password_token        :string
#  sign_in_count               :integer          default(0), not null
#  tokens                      :json
#  uid                         :string           default(""), not null
#  unconfirmed_email           :string
#  username                    :string
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_created_at            (created_at)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#  index_users_on_username              (username) UNIQUE
#

RSpec.describe User, type: :model do
  describe '#validator' do
    context 'when factory is valid' do
      subject(:user) { create(:user) }

      it { is_expected.to be_valid }
      it { expect{ user }.to change(User, :count).by(1) }
    end

    context 'with :email' do
      subject(:user) { create(:user) }

      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
    end

    context 'with :email_confirmation' do
      it { is_expected.to validate_confirmation_of(:email) }
    end

    context 'with :password' do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password).is_at_least(8).is_at_most(128) }
    end

    context 'with :password_confirmation' do
      it { is_expected.to validate_confirmation_of(:password) }
    end

    context 'with :username' do
      subject { create(:user) }

      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    end
  end

  describe '#scope' do
    context 'with :default_scope' do
      it { expect(User.all.default_scoped.to_sql).to eq User.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context 'with :id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end

    context 'with :allow_password_change' do
      it { is_expected.to have_db_column(:allow_password_change).of_type(:boolean) }
      it { is_expected.to have_db_column(:allow_password_change).with_options(default: false) }
    end

    context 'with :confirmation_sent_at' do
      it { is_expected.to have_db_column(:confirmation_sent_at).of_type(:datetime) }
    end

    context 'with :confirmation_token' do
      it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
    end

    context 'with :confirmed_at' do
      it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
    end

    context 'with :created_courses_count' do
      it { is_expected.to have_db_column(:created_courses_count).of_type(:integer) }
      it { is_expected.to have_db_column(:created_courses_count).with_options(default: 0) }
    end

    context 'with :created_lessons_count' do
      it { is_expected.to have_db_column(:created_lessons_count).of_type(:integer) }
      it { is_expected.to have_db_column(:created_lessons_count).with_options(default: 0) }
    end

    context 'with :created_organizations_count' do
      it { is_expected.to have_db_column(:created_organizations_count).of_type(:integer) }
      it { is_expected.to have_db_column(:created_organizations_count).with_options(default: 0) }
    end

    context 'with :current_sign_in_at' do
      it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    end

    context 'with :current_sign_in_ip' do
      it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:string) }
    end

    context 'with :email' do
      it { is_expected.to have_db_column(:email).of_type(:string) }
    end

    context 'with :emitted_invitations_count' do
      it { is_expected.to have_db_column(:emitted_invitations_count).of_type(:integer) }
      it { is_expected.to have_db_column(:emitted_invitations_count).with_options(default: 0) }
    end

    context 'with :encrypted_password' do
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
      it { is_expected.to have_db_column(:encrypted_password).with_options(default: '', null: false) }
    end

    context 'with :last_sign_in_at' do
      it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    end

    context 'with :last_sign_in_ip' do
      it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:string) }
    end

    context 'with :organizations_count' do
      it { is_expected.to have_db_column(:organizations_count).of_type(:integer) }
      it { is_expected.to have_db_column(:organizations_count).with_options(default: 0) }
    end

    context 'with :provider' do
      it { is_expected.to have_db_column(:provider).of_type(:string) }
      it { is_expected.to have_db_column(:provider).with_options(default: 'email', null: false) }
    end

    context 'with :received_invitations_count' do
      it { is_expected.to have_db_column(:received_invitations_count).of_type(:integer) }
      it { is_expected.to have_db_column(:received_invitations_count).with_options(default: 0) }
    end

    context 'with :remember_created_at' do
      it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    end

    context 'with :reset_password_sent_at' do
      it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    end

    context 'with :reset_password_token' do
      it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    end

    context 'with :sign_in_count' do
      it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
      it { is_expected.to have_db_column(:sign_in_count).with_options(default: 0, null: false) }
    end

    context 'with :tokens' do
      it { is_expected.to have_db_column(:tokens).of_type(:json) }
    end

    context 'with :uid' do
      it { is_expected.to have_db_column(:uid).of_type(:string) }
      it { is_expected.to have_db_column(:uid).with_options(default: '', null: false) }
    end

    context 'with :unconfirmed_email' do
      it { is_expected.to have_db_column(:unconfirmed_email).of_type(:string) }
    end

    context 'with :username' do
      it { is_expected.to have_db_column(:username).of_type(:string) }
    end

    context 'with :created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end

    context 'with :updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end
  end

  describe '#DbIndex' do
    context 'with :index_users_on_confirmation_token' do
      it { is_expected.to have_db_index(:confirmation_token).unique(true) }
    end

    context 'with :index_users_on_created_at' do
      it { is_expected.to have_db_index(:created_at) }
    end

    context 'with :index_users_on_email' do
      it { is_expected.to have_db_index(:email).unique(true) }
    end

    context 'with :index_users_on_reset_password_token' do
      it { is_expected.to have_db_index(:reset_password_token).unique(true) }
    end

    context 'with :index_users_on_uid_and_provider' do
      it { is_expected.to have_db_index(%i[uid provider]).unique(true) }
    end

    context 'with :index_users_on_username' do
      it { is_expected.to have_db_index(:username).unique(true) }
    end
  end

  describe '#relationship' do
    context 'when user has_many courses' do
      it { is_expected.to have_many(:created_courses).class_name(:Course) }
      it { is_expected.to have_many(:created_courses).with_foreign_key(:creator_id) }
      it { is_expected.to have_many(:created_courses).dependent(:destroy) }
      it { is_expected.to have_many(:created_courses).inverse_of(:creator) }
    end

    context 'when user has_many lessons' do
      it { is_expected.to have_many(:created_lessons).class_name(:Lesson) }
      it { is_expected.to have_many(:created_lessons).with_foreign_key(:creator_id) }
      it { is_expected.to have_many(:created_lessons).dependent(:destroy) }
      it { is_expected.to have_many(:created_lessons).inverse_of(:creator) }
    end

    context 'when user has_many organization_memberships' do
      it { is_expected.to have_many(:organization_memberships).with_foreign_key(:member_id) }
      it { is_expected.to have_many(:organization_memberships).dependent(:destroy) }
      it { is_expected.to have_many(:organization_memberships).inverse_of(:member) }
    end

    context 'when user has_many organizations' do
      it { is_expected.to have_many(:organizations).through(:organization_memberships) }
    end

    context 'when user has_many received_invitations' do
      it { is_expected.to have_many(:received_invitations).class_name(:Invitation) }
      it { is_expected.to have_many(:received_invitations).with_foreign_key(:invitee_id) }
      it { is_expected.to have_many(:received_invitations).dependent(:destroy) }
      it { is_expected.to have_many(:received_invitations).inverse_of(:invitee) }
    end

    context 'when user has_many emitted_invitations' do
      it { is_expected.to have_many(:emitted_invitations).class_name(:Invitation) }
      it { is_expected.to have_many(:emitted_invitations).with_foreign_key(:emitter_id) }
      it { is_expected.to have_many(:emitted_invitations).dependent(:destroy) }
      it { is_expected.to have_many(:emitted_invitations).inverse_of(:emitter) }
    end
  end

  describe '#Follows' do
    let(:user) { create(:user, :with_organizations) }
    let(:course) { create(:course, creator: user) }
    let(:lesson) { create(:lesson, course: course, creator: user) }
    let(:invitation_sent) { create(:invitation, :with_invitee, emitter: user) }
    let(:invitation_received) { create(:invitation, :with_emitter, invitee: user) }

    context 'when follows user link through courses' do
      it 'user should eq user' do
        course
        expect(user.created_courses.last.creator).to eq(user)
      end
    end

    context 'when follows user link through lessons' do
      it 'user should eq user' do
        lesson
        expect(user.created_lessons.last.creator).to eq(user)
      end
    end

    context 'when follows user link through organizations' do
      it 'user should eq user' do
        expect(user.created_organizations.last.creator).to eq(user)
      end
    end

    context 'when follows user link through organization_memberships' do
      it 'user should eq user' do
        expect(user.organization_memberships.last.member).to eq(user)
      end
    end

    context 'when follows user link of organization through organization_memberships' do
      it 'user should eq user' do
        expect(user.created_organizations.last.members.last).to eq(user)
      end
    end

    context 'when follows user link through emitted_invitations' do
      it 'user should eq user' do
        invitation_sent
        expect(user.emitted_invitations.last.emitter).to eq(user)
      end
    end

    context 'when follows user link through received_invitations' do
      it 'user should eq user' do
        invitation_received
        expect(user.received_invitations.last.invitee).to eq(user)
      end
    end
  end
end
