# == Schema Information
#
# Table name: invitations
#
#  id                :uuid             not null, primary key
#  destination_email :string
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
  # validates :destination_email, presence: true
  belongs_to :invitee, optional: true, class_name: :User, inverse_of: :received_invitations,
                       counter_cache: :received_invitations_count

  belongs_to :interest, optional: true, polymorphic: true
  belongs_to :emitter, class_name: :User, inverse_of: :emitted_invitations,
                       counter_cache: :emitted_invitations_count

  # validates :emitter_id, allow_nil: true, on: %i[create update]
  # uuid: true

  validates :interest_id, allow_nil: true, uuid: true
  # on: %i[create update],

  validates :interest_type, allow_nil: true,
                            inclusion: { message: "%{value} is not a valid interest",
                                         in: %w(Course CourseSession Organization) }

  validates :invitee_id, allow_nil: true, on: %i[create update], uuid:      true

  validates :destination_email, email: true, on: %i[create update], unless: :invitee_id?
  validates :destination_email, presence: true, on: %i[create update], unless: :invitee_id?
  validates :destination_email, absence: true, if: :invitee_id?

  # validates :sender, email: true, unless: :emitter_id?, on: %i[create update]
  # validates :sender, on: %i[create update], presence: true, unless: :emitter_id?
  # validates :sender, absence: true, if: :emitter_id?
end
