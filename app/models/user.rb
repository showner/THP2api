# == Schema Information
#
# Table name: users
#
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
#  username               :string
#  email                  :string
#  tokens                 :json
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  id                     :uuid             not null, primary key
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
