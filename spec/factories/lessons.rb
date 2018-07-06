# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  title       :string(50)       not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'faker'

FactoryBot.define do
  factory :lesson do
    title { Faker::Educator.course }
    description { Faker::FamilyGuy.quote }
  end
end
