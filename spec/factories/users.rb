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

FactoryBot.define do
  factory :user do
    transient do
      organizations_count      { 3 }
      organizations_max        { 5 }
      organizations_min        { 1 }
    end

    email    { Faker::Internet.unique.safe_email }
    username { Faker::Internet.unique.username }
    password { Faker::Internet.password(8, 20) }
    password_confirmation { password }

    trait :nousername do
      username {}
    end

    trait :confirmed do
      confirmed_at { 2.days.ago }
    end

    trait :with_organizations do
      after(:create) do |user, attributes|
        if attributes.methods.include?(:organizations_count)
          create_list(:organization, attributes.organizations_count, creator: user)
        else
          create_list(:organization, rand(attributes.organizations_min..attributes.organizations_max), creator: user)
        end
      end
    end
  end
end
