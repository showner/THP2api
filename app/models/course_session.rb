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
  validates :name, length: { allow_nil: true, maximum: 50 }
  validates :starting_date, presence: true
  validates :student_max, presence: true, numericality: { less_than: 1000 }
  validates :student_min, numericality: { greater_than: 1, allow_nil: true }

  belongs_to :course, inverse_of: :sessions, counter_cache: :sessions_count
end
