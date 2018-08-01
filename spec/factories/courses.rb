# == Schema Information
#
# Table name: courses
#
#  id            :uuid             not null, primary key
#  description   :text
#  lessons_count :integer          default(0)
#  title         :string(50)       not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :uuid
#
# Indexes
#
#  index_courses_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

FactoryBot.define do
  factory :course do
    title "MyString"
    description "MyText"
  end
end
