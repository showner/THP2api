# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  description :text
#  title       :string(50)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  creator_id  :uuid
#

FactoryBot.define do
  factory :lesson do
    title { Faker::Educator.course.first(50) }
    description { Faker::FamilyGuy.quote.first(300) }
    association :creator, factory: :user
  end
end
