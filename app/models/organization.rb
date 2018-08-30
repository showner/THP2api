# == Schema Information
#
# Table name: organizations
#
#  id                     :uuid             not null, primary key
#  created_sessions_count :integer          default(0)
#  members_count          :integer          default(0)
#  name                   :string(50)       not null
#  website                :text
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  creator_id             :uuid
#
# Indexes
#
#  index_organizations_on_creator_id  (creator_id)
#  index_organizations_on_name        (name) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

class Organization < ApplicationRecord
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { case_sensitive: false }
  validates :website, length: { maximum: 2000 }, uniqueness: { case_sensitive: false, allow_nil: true }

  belongs_to :creator, class_name: :User, inverse_of: :created_organizations,
                       counter_cache: :created_organizations_count

  has_many :created_sessions, class_name: :CourseSession, foreign_key: :creator_id,
                              dependent:  :destroy, inverse_of:  :creator

  has_many :organization_memberships, foreign_key: :organization_id,
                                      dependent: :destroy, inverse_of: :organization

  has_many :members, through: :organization_memberships

  has_many :invitations, as: :interest, dependent: :destroy
end
