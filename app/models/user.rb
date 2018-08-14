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
#  encrypted_password          :string           default(""), not null
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string
#  provider                    :string           default("email"), not null
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

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable,
         password_length: 8..128
  # , authentication_keys: [:login]
  include DeviseTokenAuth::Concerns::User

  validates :username, uniqueness: { case_sensitive: false }
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
  default_scope { order(created_at: :asc) }

  # TODO validate password_confirmation format, length etc same as password
  # TODO validate email_confirmation format, length etc same as email
  # Link to do so :
  # https://github.com/plataformatec/devise/blob/master/lib/devise/models/validatable.rb

  has_many :created_lessons, class_name: :Lesson, foreign_key: :creator_id,
                             dependent:  :destroy, inverse_of:  :creator

  has_many :created_courses, class_name: :Course, foreign_key: :creator_id,
                             dependent: :destroy, inverse_of: :creator

  has_many :created_organizations, class_name: :Organization,
                                   foreign_key: :creator_id,
                                   dependent: :destroy, inverse_of: :creator

  has_many :organization_memberships, foreign_key: :member_id,
                                      dependent: :destroy, inverse_of: :member
  has_many :organizations, through: :organization_memberships
end
