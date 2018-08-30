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
#  creator_id    :uuid
#
# Indexes
#
#  index_course_sessions_on_course_id   (course_id)
#  index_course_sessions_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (creator_id => organizations.id)
#

class CourseSession < ApplicationRecord
  attribute :starting_date, :datetime, default: -> { Time.now.tomorrow.utc.change(hour: 6, minute: 0, seconds: 0) }

  validates_datetime :starting_date, on_or_after: :tomorrow_morning
  validates_datetime :ending_date, after: ->(course_session) { course_session.starting_date + 25.minutes }, if: :ending_date
  validates :name, length: { maximum: 50 }
  validates :student_max, presence: true,
                          numericality: { only_integer: true, less_than: 1000,
                                          greater_than: ->(course_session) { course_session.student_min } }
  validates :student_min, numericality: { only_integer: true, greater_than: 1 }
  validates :student_min, numericality: { only_integer: true, less_than: :student_max }, if: :student_max, on: :update
  # validates :starting_date, presence: true
  # validates :student_max, presence: true, numericality: { less_than: 1000 }
  # validates :student_min, numericality: { only_integer: true, greater_than: 1, less_than: :student_max }, unless: :student_max.nil?, on: :update

  belongs_to :course, inverse_of: :sessions, counter_cache: :sessions_count
  belongs_to :creator, class_name: :Organization, inverse_of: :created_sessions,
                       counter_cache: :created_sessions_count
end
