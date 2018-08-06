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

class CourseSession < ApplicationRecord
  attribute :starting_date, :datetime, default: -> { Time.now.tomorrow.utc.change(hour: 9, minute: 0, seconds: 0) }

  validates :name, length: { maximum: 50 }
  validates :starting_date, presence: true
  # validates :student_max, presence: true, numericality: { less_than: 1000 }
  validates :student_min, numericality: { greater_than: 1 }
  validates :student_max, presence: true, numericality: { less_than: 1000, greater_than: ->(course_session) { course_session.student_min } }
  # validates :student_min, numericality: { greater_than: 1
  validates :student_min, numericality: { less_than: :student_max }, unless: :student_max.nil?, on: :update

  belongs_to :course, inverse_of: :sessions, counter_cache: :sessions_count
end
