require 'rails_helper'

RSpec.describe V1::InvitationsController, type: :controller do
  # With authenticated user
  context 'with auth user' do
    before { fake_user }

    describe 'GET #show' do
      subject(:invitation_request) { get :show, params: params }

      let(:invitation) { create(:valid_invitation) }
      let(:params) { { id: invitation.id } }

      context 'with :id exists' do
        include_examples 'invitation_examples', :ok
      end

      context 'with :id is not valid ' do
        let(:params) { { id: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:not_found) }
      end

      context 'when has extras params' do
        let(:params) { { id: invitation.id, another_params: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'POST #create' do
      subject(:invitation_request) { post :create, params: params }

      let(:invitation) { attributes_for(:invitation, :with_email) }
      let(:params) { { invitation: invitation } }

      context 'with valid params' do
        # it { binding.pry }
        include_examples 'invitation_examples', :created
      end

      context 'with extra params next to invitation' do
        let(:params) { { invitation: invitation, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into invitation' do
        let(:params) do
          invitation[:extra] = 'this extra params'
          { invitation: invitation }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without params" do
        it {
          params.delete(:invitation)
          is_expected.to have_http_status(:forbidden)
        }
      end

      # set correct attributes
      xcontext "without ATTRIBUTE" do
        it {
          invitation.delete(:ATTRIBUTE)
          is_expected.to have_http_status(:forbidden)
        }
      end

      xcontext "with invalid ATTRIBUTE:nil" do
        it {
          invitation[:ATTRIBUTE] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      xcontext "with invalid ATTRIBUTE:too_long" do
        it {
          invitation[:ATTRIBUTE] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe 'patch #update' do
      subject(:invitation_request) { patch :update, params: params }

      let(:invitation) { create(:invitation, :with_email, emitter: test_user) }
      let(:course) { create(:course, creator: test_user) }
      let(:invitation_update) { { interest_type: course.class, interest_id: course.id } }
      let(:params) { { id: invitation.id, invitation: invitation_update } }

      context 'with valid params' do
        # it { binding.pry }
        include_examples 'invitation_examples', :ok
      end

      xcontext 'without params' do
        let(:params) { {} }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "without id params" do
        let(:params) { { invitation: invitation_update } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "with invalid id params" do
        pending
        let(:params) { { id: Faker::Number.number(10), invitation: invitation_update } }
      end

      context 'with extra params next to invitation' do
        let(:params) { { id: invitation.id, invitation: invitation_update, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into invitation' do
        let(:params) do
          invitation_update[:extra] = 'this extra params'
          { id: invitation.id, invitation: invitation_update }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without invitation params" do
        it {
          params.delete(:invitation)
          is_expected.to have_http_status(:forbidden)
        }
      end

      # ALL FOLLOWING TESTS NEED REWORK
      xcontext "without invitation:name" do
        # invitation attribute will be empty and raise error
        let(:invitation_update) { attributes_for(:invitation).except!(:name) }

        include_examples 'invitation_examples', :ok
      end

      xcontext "with invalid invitation:name:nil" do
        it {
          invitation_update[:name] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      xcontext "with invalid invitation:name:too_long" do
        it {
          invitation_update[:name] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end

      xcontext "with invalid invitation:website:nil" do
        it {
          invitation_update[:website] = nil
          is_expected.to have_http_status(:ok)
        }
      end

      xcontext "with invalid invitation:website:too_long" do
        it {
          invitation_update[:website] = Faker::Lorem.characters(2005)
          is_expected.to have_http_status(:forbidden)
        }
      end

      xcontext "with invalid invitation params" do
        it {
          invitation_update[:name] = Faker::Lorem.characters(55)
          invitation_update[:website] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe "DELETE #destroy" do
      subject(:invitation_request) { delete :destroy, params: params }

      let(:invitation) { create(:invitation, :with_email, emitter: test_user) }
      let(:params) { { id: invitation.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:no_content) }
        it 'delete in db' do
          invitation
          expect{ invitation_request }.to change(Invitation, :count).by(-1)
        end
      end

      xcontext "with invalid id" do
        let(:params) { { id: Faker::Number.number(10) } }
        # Controller To be changed to forbidden

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "with extra params" do
        let(:params) { { id: invitation.id, extra: 'extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "without params" do
        pending
        let(:params) { {} }
      end

      xcontext "only with extra params" do
        pending
        let(:params) { { extra: 'extra params' } }
      end
    end
  end

  # Creator != logged user

  xcontext 'with other auth user' do
    before { fake_user }

    describe 'patch #update' do
      subject { patch :update, params: params }

      let(:invitation) { create(:invitation) }
      let(:invitation_update) { attributes_for(:invitation) }
      let(:params) { { id: invitation.id, invitation: invitation_update } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context 'with extra params next to invitation' do
        let(:params) { { id: invitation.id, invitation: invitation_update, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:invitation) { create(:invitation) }
      let(:params) { { id: invitation.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context "with extra params" do
        let(:params) { { id: invitation.id, extra: 'extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end

  # Without authenticated user

  xcontext 'without auth user' do
    describe "GET #index" do
      subject { get :index }

      invitation_count = 5
      let(:invitations) { create_list(:invitation, invitation_count) }

      context 'with valid request' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'GET #show' do
      subject { get :show, params: params }

      let(:invitation) { create(:invitation) }
      let(:params) { { id: invitation.id } }

      context 'with :id exists ' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'POST #create' do
      subject { post :create, params: params }

      let(:invitation) { attributes_for(:invitation) }
      let(:params) { { invitation: invitation } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'patch #update' do
      subject { patch :update, params: params }

      let(:invitation) { create(:invitation) }
      let(:invitation_update) { attributes_for(:invitation) }
      let(:params) { { id: invitation.id, invitation: invitation_update } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:invitation) { create(:invitation) }
      let(:params) { { id: invitation.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
end
