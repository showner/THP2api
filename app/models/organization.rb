# == Schema Information
#
# Table name: organizations
#
#  id         :uuid             not null, primary key
#  name       :string(50)       not null
#  website    :text             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  creator_id :uuid
#
# Indexes
#
#  index_organizations_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

class Organization < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :website, length: { maximum: 2000 }, uniqueness: { case_sensitive: false }

  belongs_to :creator, class_name: :User, inverse_of: :created_organizations,
                       counter_cache: :created_organizations_count
end
