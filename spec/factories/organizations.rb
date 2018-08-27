# == Schema Information
#
# Table name: organizations
#
#  id                     :uuid             not null, primary key
#  created_sessions_count :integer          default(0)
#  members_count          :integer          default(0)
#  name                   :string(50)       not null
#  website                :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  creator_id             :uuid
#
# Indexes
#
#  index_organizations_on_creator_id  (creator_id)
#  index_organizations_on_name        (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

FactoryBot.define do
  factory :organization do
    transient do
      sessions_count      { 3 }
      sessions_max        { 5 }
      sessions_min        { 1 }
    end

    name { Faker::Company.unique.name.first(50) }
    association :creator, factory: :user
    after(:create) do |organization|
      organization.members << organization.creator
    end

    trait :with_sessions do
      after(:create) do |organization, attributes|
        course = create(:course)
        if attributes.methods.include?(:sessions_count)
          create_list(:course_session, attributes.sessions_count, course: course, creator: organization)
        else
          create_list(:course_session, rand(attributes.sessions_min..attributes.sessions_max), course: course, creator: organization)
        end
      end
    end
  end
end
