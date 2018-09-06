require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe 'notice_invitee' do
    let(:invitation) { create(:valid_invitation) }
    let(:mail) { InvitationMailer.with(invitation).notice_invitee }

    context "with the headers" do
      it "returns subject" do
        expect(mail.subject).to eq("Invitation")
      end
      it "returns destination" do
        expect(mail.to).to eq([invitation.invitee.email])
      end
      xit "returns from" do
        expect(mail.from).to eq([invitation.emitter.email])
      end
    end

    context "with the body" do
      it { expect(mail.body.encoded).to match("you received this mail because of this:") }
    end
  end
end
