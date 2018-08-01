# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  created_courses_count  :integer          default(0)
#  created_lessons_count  :integer          default(0)
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
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
    context 'factory is valid' do
      subject { create(:user) }
      it { is_expected.to be_valid }
      it { expect{ subject }.to change{ User.count }.by(1) }
    end

    context ':email' do
      subject { create(:user) }
      it { is_expected.to validate_presence_of(:email) }
      it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
    end

    context ':email_confirmation' do
      it { is_expected.to validate_confirmation_of(:email) }
    end

    context ':password' do
      it { is_expected.to validate_presence_of(:password) }
      it { is_expected.to validate_length_of(:password). is_at_least(8).is_at_most(128) }
    end

    context ':password_confirmation' do
      it { is_expected.to validate_confirmation_of(:password) }
    end

    context ':username' do
      subject { create(:user) }
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    end
  end

  describe '#scope' do
    context ':default_scope' do
      it { expect(User.all.default_scoped.to_sql).to eq User.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context ':id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end
    context ':allow_password_change' do
      it { is_expected.to have_db_column(:allow_password_change).of_type(:boolean) }
      it { is_expected.to have_db_column(:allow_password_change).with_options(default: false) }
    end
    context ':confirmation_sent_at' do
      it { is_expected.to have_db_column(:confirmation_sent_at).of_type(:datetime) }
    end
    context ':confirmation_token' do
      it { is_expected.to have_db_column(:confirmation_token).of_type(:string) }
    end
    context ':confirmed_at' do
      it { is_expected.to have_db_column(:confirmed_at).of_type(:datetime) }
    end
    context ':created_lessons_count' do
      it { is_expected.to have_db_column(:created_lessons_count).of_type(:integer) }
      it { is_expected.to have_db_column(:created_lessons_count).with_options(default: 0) }
    end
    context ':current_sign_in_at' do
      it { is_expected.to have_db_column(:current_sign_in_at).of_type(:datetime) }
    end
    context ':current_sign_in_ip' do
      it { is_expected.to have_db_column(:current_sign_in_ip).of_type(:string) }
    end
    context ':email' do
      it { is_expected.to have_db_column(:email).of_type(:string) }
    end
    context ':encrypted_password' do
      it { is_expected.to have_db_column(:encrypted_password).of_type(:string) }
      it { is_expected.to have_db_column(:encrypted_password).with_options(default: '', null: false) }
    end
    context ':last_sign_in_at' do
      it { is_expected.to have_db_column(:last_sign_in_at).of_type(:datetime) }
    end
    context ':last_sign_in_ip' do
      it { is_expected.to have_db_column(:last_sign_in_ip).of_type(:string) }
    end
    context ':provider' do
      it { is_expected.to have_db_column(:provider).of_type(:string) }
      it { is_expected.to have_db_column(:provider).with_options(default: 'email', null: false) }
    end
    context ':remember_created_at' do
      it { is_expected.to have_db_column(:remember_created_at).of_type(:datetime) }
    end
    context ':reset_password_sent_at' do
      it { is_expected.to have_db_column(:reset_password_sent_at).of_type(:datetime) }
    end
    context ':reset_password_token' do
      it { is_expected.to have_db_column(:reset_password_token).of_type(:string) }
    end
    context ':sign_in_count' do
      it { is_expected.to have_db_column(:sign_in_count).of_type(:integer) }
      it { is_expected.to have_db_column(:sign_in_count).with_options(default: 0, null: false) }
    end
    context ':tokens' do
      it { is_expected.to have_db_column(:tokens).of_type(:json) }
    end
    context ':uid' do
      it { is_expected.to have_db_column(:uid).of_type(:string) }
      it { is_expected.to have_db_column(:uid).with_options(default: '', null: false) }
    end
    context ':unconfirmed_email' do
      it { is_expected.to have_db_column(:unconfirmed_email).of_type(:string) }
    end
    context ':username' do
      it { is_expected.to have_db_column(:username).of_type(:string) }
    end
    context ':created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end
    context ':updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end
  end

  describe '#DbIndex' do
    context ':index_users_on_confirmation_token' do
      it { is_expected.to have_db_index(:confirmation_token).unique(true) }
    end
    context ':index_users_on_created_at' do
      it { is_expected.to have_db_index(:created_at) }
    end
    context ':index_users_on_email' do
      it { is_expected.to have_db_index(:email).unique(true) }
    end
    context ':index_users_on_reset_password_token' do
      it { is_expected.to have_db_index(:reset_password_token).unique(true) }
    end
    context ':index_users_on_uid_and_provider' do
      it { is_expected.to have_db_index(%i[uid provider]).unique(true) }
    end
    context ':index_users_on_username' do
      it { is_expected.to have_db_index(:username).unique(true) }
    end
  end

  describe '#relationship' do
    context 'lesson creation' do
      it { is_expected.to have_many(:created_lessons).class_name(:Lesson) }
      it { is_expected.to have_many(:created_lessons).with_foreign_key(:creator_id) }
      it { is_expected.to have_many(:created_lessons).dependent(:destroy) }
      it { is_expected.to have_many(:created_lessons).inverse_of(:creator) }
    end
    context 'follows lesson link' do
      let(:user) { create(:user) }
      let!(:lesson) { create(:lesson, creator: user) }
      it 'user should eq user' do
        expect(user.created_lessons.first.creator).to eq(user)
      end
    end
  end
end
