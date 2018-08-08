# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  description :text             not null
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

class LessonSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :creator_id, :course_id
end
