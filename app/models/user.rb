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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         password_length: 8..128
  # , authentication_keys: [:login]
  include DeviseTokenAuth::Concerns::User

  validates :username, uniqueness: { case_sensitive: false, allow_nil: true }
  validates :email, confirmation: true
  # validates :email, uniqueness: true
  # validates :email, format: { on: %i[:create, :update] }

  # https://github.com/plataformatec/devise/wiki/How-To:-Allow-users-to
  # -sign-in-using-their-username-or-email-address
  # attr_writer :login
  # def login
  #   @login || username || email
  # end

  # def confirmation_required?
  #   false
  # end
  default_scope -> { order("created_at ASC") }

  # TODO validate password_confirmation format, length etc same as password
  # TODO validate email_confirmation format, length etc same as email
  # Link to do so https://github.com/plataformatec/devise/blob/master/lib/devise/models/validatable.rb
end
