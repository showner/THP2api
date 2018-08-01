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

class Course < ApplicationRecord
  belongs_to :creator, class_name: :User, inverse_of: :created_courses,
                       counter_cache: :created_courses_count

  has_many :lessons, dependent: :destroy
end
