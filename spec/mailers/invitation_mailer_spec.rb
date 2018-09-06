require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe 'notice_invitee' do
    subject(:mail) { described_class.notice_invitee(invitation) }

    let(:invitation) { create(:valid_invitation) }

    context "with the headers" do
      it "returns mail subject" do
        expect(mail.subject).to eq("Invitation")
      end
      it "returns mail destination" do
        expect(mail.to).to eq([invitation.invitee.email])
      end
      it "returns mail from" do
        # binding.pry
        expect(mail.from).to eq([InvitationMailer.default[:from]])
      end
    end

    context "with the body" do
      # https://www.lucascaton.com.br/2010/10/25/how-to-test-mailers-in-rails-with-rspec/
      it { expect(mail.body.encoded).to match("you received this mail because of this:") }
    end

    context 'when have access to URL helpers' do
      it { expect { v1_invitation_url(invitation) }.not_to raise_error }
    end
  end
end
