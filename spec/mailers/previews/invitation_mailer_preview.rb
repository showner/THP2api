# Preview all emails at http://localhost:3000/rails/mailers/invitation_mailer
require 'factory_bot'

class InvitationMailerPreview < ActionMailer::Preview
  def inform_invitee
    InvitationMailer.notice_invitee(FactoryBot.create(:valid_invitation))
  end
end
