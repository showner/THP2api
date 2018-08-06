# == Schema Information
#
# Table name: course_sessions
#
#  id            :uuid             not null, primary key
#  ending_date   :datetime
#  name          :string(50)
#  starting_date :datetime         not null
#  student_max   :integer          not null
#  student_min   :integer          default(2), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :uuid
#
# Indexes
#
#  index_course_sessions_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#

FactoryBot.define do
  factory :course_session do
    ending_date   { Faker::Date.between(3.weeks.from_now, 4.weeks.from_now) }
    name          { Faker::Book.title.first(50) }
    starting_date { Faker::Date.between(1.week.from_now, 2.weeks.from_now) }
    student_max   { 999 }
    association :course

    trait :student_10_min do
      student_min { 10 }
    end
  end
end
