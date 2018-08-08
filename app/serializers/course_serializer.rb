# == Schema Information
#
# Table name: courses
#
#  id             :uuid             not null, primary key
#  description    :text             not null
#  lessons_count  :integer          default(0)
#  sessions_count :integer          default(0)
#  title          :string(50)       not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :uuid
#
# Indexes
#
#  index_courses_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

class CourseSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :created_at, :updated_at, :creator_id,
             :lessons_count
  has_many :lessons
end
