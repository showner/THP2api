# == Schema Information
#
# Table name: invitations
#
#  id                :uuid             not null, primary key
#  destination_email :string           not null
#  interest_type     :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  emitter_id        :uuid
#  interest_id       :uuid
#  invitee_id        :uuid
#
# Indexes
#
#  index_invitations_on_emitter_id                     (emitter_id)
#  index_invitations_on_interest_type_and_interest_id  (interest_type,interest_id)
#  index_invitations_on_invitee_id                     (invitee_id)
#
# Foreign Keys
#
#  fk_rails_...  (emitter_id => users.id)
#  fk_rails_...  (invitee_id => users.id)
#

class Invitation < ApplicationRecord
  belongs_to :interest, polymorphic: true
  belongs_to :invitee, class_name: :User, inverse_of: :received_invitations,
                       counter_cache: :received_invitations_count
  belongs_to :emitter, class_name: :User, inverse_of: :emitted_invitations,
                       counter_cache: :emitted_invitations_count
end
