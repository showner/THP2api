# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `uuid`             | `not null, primary key`
# **`allow_password_change`**   | `boolean`          | `default(FALSE)`
# **`confirmation_sent_at`**    | `datetime`         |
# **`confirmation_token`**      | `string`           |
# **`confirmed_at`**            | `datetime`         |
# **`current_sign_in_at`**      | `datetime`         |
# **`current_sign_in_ip`**      | `string`           |
# **`email`**                   | `string`           |
# **`encrypted_password`**      | `string`           | `default(""), not null`
# **`last_sign_in_at`**         | `datetime`         |
# **`last_sign_in_ip`**         | `string`           |
# **`provider`**                | `string`           | `default("email"), not null`
# **`remember_created_at`**     | `datetime`         |
# **`reset_password_sent_at`**  | `datetime`         |
# **`reset_password_token`**    | `string`           |
# **`sign_in_count`**           | `integer`          | `default(0), not null`
# **`tokens`**                  | `json`             |
# **`uid`**                     | `string`           | `default(""), not null`
# **`unconfirmed_email`**       | `string`           |
# **`username`**                | `string`           |
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_users_on_confirmation_token` (_unique_):
#     * **`confirmation_token`**
# * `index_users_on_created_at`:
#     * **`created_at`**
# * `index_users_on_email` (_unique_):
#     * **`email`**
# * `index_users_on_reset_password_token` (_unique_):
#     * **`reset_password_token`**
# * `index_users_on_uid_and_provider` (_unique_):
#     * **`uid`**
#     * **`provider`**
# * `index_users_on_username` (_unique_):
#     * **`username`**
#

RSpec.describe User, type: :model do
  subject { create(:user) }
  context 'factory is valid' do
    it { is_expected.to be_valid }
    it { expect{ subject }.to change{ User.count }.by(1) }
  end

  context ':email' do
    it { is_expected.to validate_presence_of(:email) }
    xit { is_expected.to validate_uniqueness_of(:email).scoped_to(:provider).case_insensitive }
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
