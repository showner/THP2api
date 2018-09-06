class InvitationMailer < ApplicationMailer
  # attr_reader @invitation
  default from: 'showner@showner.fr'

  def notice_invitee(invitation)
    # binding.pry
    @invitee = invitation.invitee
    @invitation = invitation
    mail(to: @invitee.email, subject: 'Invitation')
  end
end
