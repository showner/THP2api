# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                          | Type               | Attributes
# ----------------------------- | ------------------ | ---------------------------
# **`id`**                      | `bigint(8)`        | `not null, primary key`
# **`allow_password_change`**   | `boolean`          | `default(FALSE)`
# **`confirmation_sent_at`**    | `datetime`         |
# **`confirmation_token`**      | `string`           |
# **`confirmed_at`**            | `datetime`         |
# **`current_sign_in_at`**      | `datetime`         |
# **`current_sign_in_ip`**      | `string`           |
# **`email`**                   | `string`           |
# **`encrypted_password`**      | `string`           | `default(""), not null`
# **`image`**                   | `string`           |
# **`last_sign_in_at`**         | `datetime`         |
# **`last_sign_in_ip`**         | `string`           |
# **`name`**                    | `string`           |
# **`nickname`**                | `string`           |
# **`provider`**                | `string`           | `default("email"), not null`
# **`remember_created_at`**     | `datetime`         |
# **`reset_password_sent_at`**  | `datetime`         |
# **`reset_password_token`**    | `string`           |
# **`sign_in_count`**           | `integer`          | `default(0), not null`
# **`tokens`**                  | `json`             |
# **`uid`**                     | `string`           | `default(""), not null`
# **`unconfirmed_email`**       | `string`           |
# **`created_at`**              | `datetime`         | `not null`
# **`updated_at`**              | `datetime`         | `not null`
#
# ### Indexes
#
# * `index_users_on_confirmation_token` (_unique_):
#     * **`confirmation_token`**
# * `index_users_on_email` (_unique_):
#     * **`email`**
# * `index_users_on_reset_password_token` (_unique_):
#     * **`reset_password_token`**
# * `index_users_on_uid_and_provider` (_unique_):
#     * **`uid`**
#     * **`provider`**
#

RSpec.describe User, type: :model do
  it 'is creatable' do
    lesson = create(:lesson)
    last_lesson = Lesson.last
    expect(last_lesson.title).to eq(lesson.title)
    expect(last_lesson.title).not_to be_blank
    expect(last_lesson.description).to eq(lesson.description)
    expect(last_lesson.description).not_to be_blank
  end

  context 'increment Lesson count' do
    it { expect{ create(:lesson) }.to change{ Lesson.count }.by(1) }
  end
  context ':title' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(50) }
  end
  context ':description' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
  end
end
