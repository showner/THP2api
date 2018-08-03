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

require 'rails_helper'

RSpec.describe CourseSession, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
