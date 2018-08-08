require 'rails_helper'

RSpec.describe V1::CourseSessionsController, type: :controller do
  # With authenticated user
  context 'with auth user' do
    before(:each) {
      fake_user
    }
    # creating course for routing
    let(:course) { create(:course) }
    let(:course_params) { { course_id: course.id } }
    let(:params) { course_params }

    describe "GET #index" do
      course_session_count = 5
      let!(:course_sessions) { create_list(:course_session, course_session_count) }
      subject { get :index, params: params }
      context 'with valid request'
      it { is_expected.to have_http_status(:ok) }
      it "returns #{course_session_count} CourseSession" do
        subject
        expect(response_from_json.size).to eq(course_session_count)
        expect(response_from_json.map{ |e| e[:id] }).to eq(course_sessions.map(&:id))
      end

      context 'with extra params' do
        subject { get :index, params: params.merge(another_params: Faker::Lorem.word) }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'GET #show' do
      let(:course_session) { create(:course_session, course: course) }
      let(:course_session_params) { { id: course_session.id } }
      let(:params) { course_params.merge(course_session_params) }
      subject { get :show, params: params }

      context ':id exists' do
        include_examples 'course_session_examples', :ok
      end

      context ":id is not valid " do
        let(:params) { course_params.merge(id: Faker::Lorem.word) }
        it { is_expected.to have_http_status(:not_found) }
      end

      context "has extras params" do
        let(:params) { course_params.merge(id: course_session.id, another_params: Faker::Lorem.word) }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'POST #create' do
      let(:course_session) { attributes_for(:course_session) }
      let(:params) { { course_session: course_session, course_id: course.id } }
      subject { post :create, params: params }

      context 'with valid params' do
        include_examples 'course_session_examples', :created
      end

      context 'with complete valid params' do
        let(:course_session) { attributes_for(:course_session, :complete) }
        include_examples 'course_session_examples', :created
      end

      context 'with extra params next to course_session' do
        let(:params) { course_params.merge(course_session: course_session, extra: 'this extra params') }
        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into course_session' do
        let(:params) do
          { course_id: course.id, course_session: course_session.merge(extra: 'this extra params') }
        end
        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without params" do
        it {
          params.delete(:course_session)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without student_max" do
        it {
          course_session.delete(:student_max)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid starting_date:in_past" do
        it {
          course_session[:starting_date] = 1.day.ago
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid student_max:nil" do
        it {
          course_session[:student_max] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid student_max:too_high" do
        it {
          course_session[:student_max] = 1001
          is_expected.to have_http_status(:forbidden)
        }
      end

      xcontext "with invalid ending_date:string instead of datetime" do
        it {
          course_session[:ending_date] = "not-a-valid-date"
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid ending_date:in_past" do
        it {
          course_session[:ending_date] = 1.day.ago
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid ending_date:before starting_date" do
        it {
          course_session[:ending_date] = 4.days.from_now
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid params" do
        it {
          course_session[:starting_date] = Faker::Lorem.characters(55)
          course_session[:student_max] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe 'patch #update' do
      let(:course_session) { create(:course_session) }
      let(:course_session_update) { attributes_for(:course_session) }
      let(:params) { course_params.merge(id: course_session.id, course_session: course_session_update) }
      subject { patch :update, params: params }

      context 'with valid params' do
        include_examples 'course_session_examples', :ok
      end

      xcontext 'without params' do
        let(:params) { {} }
        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "without id params" do
        let(:params) { { course_session: course_session_update } }
        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "with invalid id params" do
        let(:params) { { id: Faker::Number.number(10), course_session: course_session_update } }
      end

      context 'with extra params next to course_session' do
        let(:params) { course_params.merge(id: course_session.id, course_session: course_session_update, extra: 'this extra params') }
        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into course_session' do
        let(:params) do
          { course_id: course.id, id: course_session.id, course_session: course_session_update.merge(extra: 'this extra params') }
        end
        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without course_session params" do
        it {
          params.delete(:course_session)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without course_session:starting_date" do
        let(:course_session_update) { attributes_for(:course_session, :complete).except!(:starting_date) }
        include_examples 'course_session_examples', :ok
      end

      context "without course_session:student_max" do
        let(:course_session_update) { attributes_for(:course_session, :complete).except!(:student_max) }
        include_examples 'course_session_examples', :ok
      end

      context "with invalid course_session:starting_date:nil" do
        it {
          course_session_update[:starting_date] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
      context "with invalid course_session:starting_date:in_past" do
        it {
          course_session_update[:starting_date] = 1.day.ago
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid course_session:student_max:nil" do
        it {
          course_session_update[:student_max] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid course_session:student_max:too_high" do
        it {
          course_session_update[:student_max] = 1001
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid course_session params" do
        it {
          course_session_update[:starting_date] = 1.week.ago
          course_session_update[:student_max] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe "DELETE #destroy" do
      let(:course_session) { create(:course_session) }
      let(:params) { course_params.merge(id: course_session.id) }
      subject { delete :destroy, params: params }
      context "with valid id" do
        it { is_expected.to have_http_status(:no_content) }
        it 'delete in db' do
          course_session
          expect{ subject }.to change(CourseSession, :count).by(-1)
        end
      end

      xcontext "with invalid id" do
        let(:params) { { id: Faker::Number.number(10) } }
        # Controller To be changed to forbidden
        it { is_expected.to have_http_status(:forbidden) }
      end

      context "with extra params" do
        let(:params) { course_params.merge(id: course_session.id, extra: 'extra params') }
        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "without params" do
        let(:params) { {} }
      end

      xcontext "only with extra params" do
        let(:params) { { extra: 'extra params' } }
      end
    end
  end
  # Is logged and part of the organization
  #
  # Without authenticated user
  context 'without auth user' do
    # creating course for routing
    let(:course) { create(:course) }
    let(:course_params) { { course_id: course.id } }
    let(:params) { course_params }

    describe "GET #index" do
      course_session_count = 5
      let!(:course_sessions) { create_list(:course_session, course_session_count) }
      subject { get :index, params: course_params }
      context 'with valid request' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'GET #show' do
      let(:course_session) { create(:course_session) }
      let(:params) { course_params.merge(id: course_session.id) }
      subject { get :show, params: params }

      context ":id exists " do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'POST #create' do
      let(:course_session) { attributes_for(:course_session) }
      let(:params) { course_params.merge(course_session: course_session) }
      subject { post :create, params: params }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'patch #update' do
      let(:course_session) { create(:course_session) }
      let(:course_session_update) { attributes_for(:course_session) }
      let(:params) { course_params.merge(id: course_session.id, course_session: course_session_update) }
      subject { patch :update, params: params }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe "DELETE #destroy" do
      let!(:course_session) { create(:course_session) }
      let(:params) { course_params.merge(id: course_session.id) }
      subject { delete :destroy, params: params }
      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
end
