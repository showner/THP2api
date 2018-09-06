class InvitationMailer < ApplicationMailer
  # attr_reader @invitation
  default from: 'showner@showner.fr'

  def notice_invitee
    # binding.pry
    @invitee = params.invitee
    @invitation = params
    mail(to: @invitee.email, subject: 'Invitation')
  end
end
