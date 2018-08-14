# == Schema Information
#
# Table name: organizations
#
#  id            :uuid             not null, primary key
#  members_count :integer          default(0)
#  name          :string(50)       not null
#  website       :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :uuid
#
# Indexes
#
#  index_organizations_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

require 'rails_helper'

RSpec.describe Organization, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
