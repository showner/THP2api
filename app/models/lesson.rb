# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  description :text
#  title       :string(50)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :uuid
#  creator_id  :uuid
#
# Indexes
#
#  index_lessons_on_course_id   (course_id)
#  index_lessons_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (creator_id => users.id)
#

class Lesson < ApplicationRecord
  validates :title, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 300 }

  belongs_to :creator, class_name: :User, inverse_of: :created_lessons,
                       counter_cache: :created_lessons_count

  belongs_to :course, counter_cache: true
end
