require 'rails_helper'

RSpec.describe V1::OrganizationsController, type: :controller do
  # With authenticated user
  context 'with auth user' do
    before { fake_user }

    describe "GET #index" do
      subject(:organization_request) { get :index }

      organization_count = 5
      let!(:organizations) { create_list(:organization, organization_count) }

      context 'with valid request' do
        it { is_expected.to have_http_status(:ok) }
        it "returns #{organization_count} Organizations" do
          organization_request
          expect(response_from_json.size).to eq(organization_count)
        end

        it "returns #{organization_count} Organizations" do
          organization_request
          expect(response_from_json.map{ |e| e[:id] }).to eq(organizations.map(&:id))
        end
      end

      context 'with extra params' do
        subject { get :index, params: { another_params: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'GET #show' do
      subject(:organization_request) { get :show, params: params }

      let(:organization) { create(:organization) }
      let(:params) { { id: organization.id } }

      context 'with :id exists' do
        include_examples 'organization_examples', :ok
      end

      context 'with :id is not valid ' do
        let(:params) { { id: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:not_found) }
      end

      context 'when has extras params' do
        let(:params) { { id: organization.id, another_params: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'POST #create' do
      subject(:organization_request) { post :create, params: params }

      let(:organization) { attributes_for(:organization) }
      let(:params) { { organization: organization } }

      context 'with valid params' do
        include_examples 'organization_examples', :created
      end

      context 'with extra params next to organization' do
        let(:params) { { organization: organization, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into organization' do
        let(:params) do
          organization[:extra] = 'this extra params'
          { organization: organization }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without params" do
        it {
          params.delete(:organization)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without name" do
        it {
          organization.delete(:name)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid name:nil" do
        it {
          organization[:name] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid name:too_long" do
        it {
          organization[:name] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid website:too_long" do
        it {
          organization[:website] = Faker::Lorem.characters(2005)
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe 'patch #update' do
      subject(:organization_request) { patch :update, params: params }

      let(:organization) { create(:organization, creator: test_user) }
      let(:organization_update) { attributes_for(:organization) }
      let(:params) { { id: organization.id, organization: organization_update } }

      context 'with valid params' do
        include_examples 'organization_examples', :ok
      end

      xcontext 'without params' do
        let(:params) { {} }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "without id params" do
        let(:params) { { organization: organization_update } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "with invalid id params" do
        pending
        let(:params) { { id: Faker::Number.number(10), organization: organization_update } }
      end

      context 'with extra params next to organization' do
        let(:params) { { id: organization.id, organization: organization_update, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into organization' do
        let(:params) do
          organization_update[:extra] = 'this extra params'
          { id: organization.id, organization: organization_update }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without organization params" do
        it {
          params.delete(:organization)
          is_expected.to have_http_status(:forbidden)
        }
      end

      xcontext "without organization:name" do
        # organization attribute will be empty and raise error
        let(:organization_update) { attributes_for(:organization).except!(:name) }

        include_examples 'organization_examples', :ok
      end

      context "with invalid organization:name:nil" do
        it {
          organization_update[:name] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid organization:name:too_long" do
        it {
          organization_update[:name] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid organization:website:nil" do
        it {
          organization_update[:website] = nil
          is_expected.to have_http_status(:ok)
        }
      end

      context "with invalid organization:website:too_long" do
        it {
          organization_update[:website] = Faker::Lorem.characters(2005)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid organization params" do
        it {
          organization_update[:name] = Faker::Lorem.characters(55)
          organization_update[:website] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe "DELETE #destroy" do
      subject(:organization_request) { delete :destroy, params: params }

      let(:organization) { create(:organization, creator: test_user) }
      let(:params) { { id: organization.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:no_content) }
        it 'delete in db' do
          organization
          expect{ organization_request }.to change(Organization, :count).by(-1)
        end
      end

      xcontext "with invalid id" do
        let(:params) { { id: Faker::Number.number(10) } }
        # Controller To be changed to forbidden

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "with extra params" do
        let(:params) { { id: organization.id, extra: 'extra params' } }

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

  context 'with other auth user' do
    before { fake_user }

    describe 'patch #update' do
      subject { patch :update, params: params }

      let(:organization) { create(:organization) }
      let(:organization_update) { attributes_for(:organization) }
      let(:params) { { id: organization.id, organization: organization_update } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context 'with extra params next to organization' do
        let(:params) { { id: organization.id, organization: organization_update, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:organization) { create(:organization) }
      let(:params) { { id: organization.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context "with extra params" do
        let(:params) { { id: organization.id, extra: 'extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end

  # Without authenticated user

  context 'without auth user' do
    describe "GET #index" do
      subject { get :index }

      organization_count = 5
      let(:organizations) { create_list(:organization, organization_count) }

      context 'with valid request' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'GET #show' do
      subject { get :show, params: params }

      let(:organization) { create(:organization) }
      let(:params) { { id: organization.id } }

      context 'with :id exists ' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'POST #create' do
      subject { post :create, params: params }

      let(:organization) { attributes_for(:organization) }
      let(:params) { { organization: organization } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'patch #update' do
      subject { patch :update, params: params }

      let(:organization) { create(:organization) }
      let(:organization_update) { attributes_for(:organization) }
      let(:params) { { id: organization.id, organization: organization_update } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:organization) { create(:organization) }
      let(:params) { { id: organization.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
end
