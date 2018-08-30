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

class InvitationSerializer < ActiveModel::Serializer
  attributes :id, :destination_email, :created_at, :updated_at, :emitter_id,
             :interest_id, :interest_type, :invitee_id
end
