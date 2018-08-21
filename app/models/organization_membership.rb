# == Schema Information
#
# Table name: organization_memberships
#
#  id              :uuid             not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  member_id       :uuid
#  organization_id :uuid
#
# Indexes
#
#  index_organization_memberships_on_member_id        (member_id)
#  index_organization_memberships_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (member_id => users.id)
#  fk_rails_...  (organization_id => organizations.id)
#

class OrganizationMembership < ApplicationRecord
  belongs_to :organization, class_name: :Organization,
                            inverse_of: :organization_memberships,
                            counter_cache: :members_count
  belongs_to :member, class_name: :User,
                      inverse_of: :organization_memberships,
                      counter_cache: :organizations_count
end
