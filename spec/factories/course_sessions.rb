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
    student_max { rand(11...1000) }
    association :course

    trait :complete do
      starting_date { Faker::Time.between(1.week.from_now, 2.weeks.from_now) }
      ending_date   { Faker::Time.between(3.weeks.from_now, 4.weeks.from_now) }
      # ending_date   { starting_date + 1.day } Need to change way of writing test (attributes_for except)
      name          { Faker::Book.title.first(50) }
    end

    trait :student_10_min do
      student_min { 10 }
    end

    trait :with_error_ending_in_past do
      ending_date { 1.day.ago }
    end

    trait :with_error_starting_in_past do
      starting_date { 1.day.ago }
    end

    trait :with_error_ending_before_starting do
      ending_date   { 1.day.from_now }
      starting_date { 2.days.from_now }
    end
  end
end
