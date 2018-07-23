# == Schema Information
#
# Table name: users
#
#  id                     :bigint(8)        not null, primary key
#  provider               :string           default("email"), not null
#  uid                    :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  allow_password_change  :boolean          default(FALSE)
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  name                   :string
#  nickname               :string
#  image                  :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

RSpec.describe User, type: :model do
  context 'is valid' do
    it { expect(create(:user)).to be_valid }
  end

  context 'increment Lesson count' do
    it { expect{ create(:user) }.to change{ User.count }.by(1) }
  end
  context ':email' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
  end
  context ':password' do
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_length_of(:password). is_at_least(8).is_at_most(128) }
  end
  context ':nickname' do
    it { is_expected.to validate_uniqueness_of(:nickname).case_insensitive.allow_nil }
  end
end
