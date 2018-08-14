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

FactoryBot.define do
  factory :organization do
  end
end
