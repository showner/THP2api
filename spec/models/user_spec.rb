# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
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
    subject { create(:user) }
    context 'factory is valid' do
      it { is_expected.to be_valid }
      it { expect{ subject }.to change{ User.count }.by(1) }
    end

    context ':email' do
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
      it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    end
  end

  describe '#scope' do
    context ':default_scope' do
      it { expect(User.all.default_scoped.to_sql).to eq User.all.to_sql }
    end
  end

  describe '#relationship' do
    context 'lesson creation' do
      it { is_expected.to have_many(:created_lessons).class_name(:Lesson) }
      it { is_expected.to have_many(:created_lessons).with_foreign_key('creator_id') }
      it { is_expected.to have_many(:created_lessons).dependent(:destroy) }
      it { is_expected.to have_many(:created_lessons).inverse_of(:creator) }
    end
    xcontext 'follows lesson link' do
    end
  end
end
