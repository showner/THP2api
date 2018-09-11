require 'rails_helper'

RSpec.describe V1::CoursesController, type: :controller do
  # With authenticated user
  context 'with auth user' do
    before { fake_user }

    describe "GET #index" do
      subject(:course_request) { get :index }

      before { create_list(:course, 5) }

      let(:courses_page_one) { Course.order(created_at: :asc).limit(5) }

      context 'with valid request' do
        it { is_expected.to have_http_status(:ok) }

        it "returns 5 Courses" do
          course_request
          expect(response_from_json_as('courses').size).to eq(5)
        end

        it "returns the 5 Courses" do
          course_request
          expect(response_from_json_as('courses').map{ |e| e[:id] }).to eq(courses_page_one.map(&:id))
        end
      end

      context 'with extra params' do
        subject { get :index, params: { another_params: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'GET #show' do
      subject(:course_request) { get :show, params: params }

      let(:course) { create(:course) }
      let(:params) { { id: course.id } }

      context 'with :id exists' do
        include_examples 'course_examples', :ok
      end

      context 'with :id is not valid ' do
        let(:params) { { id: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:not_found) }
      end

      context 'when has extras params' do
        let(:params) { { id: course.id, another_params: Faker::Lorem.word } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'POST #create' do
      subject(:course_request) { post :create, params: params }

      let(:course) { attributes_for(:course) }
      let(:params) { { course: course } }

      context 'with valid params' do
        include_examples 'course_examples', :created
      end

      context 'with extra params next to course' do
        let(:params) { { course: course, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into course' do
        let(:params) do
          course[:extra] = 'this extra params'
          { course: course }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without params" do
        it {
          params.delete(:course)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without title" do
        it {
          course.delete(:title)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without description" do
        it {
          course.delete(:description)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid title:nil" do
        it {
          course[:title] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid title:too_long" do
        it {
          course[:title] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid description:nil" do
        it {
          course[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid description:too_long" do
        it {
          course[:description] = Faker::Lorem.characters(350)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid params" do
        it {
          course[:title] = Faker::Lorem.characters(55)
          course[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe 'patch #update' do
      subject(:course_request) { patch :update, params: params }

      let(:course) { create(:course, creator: test_user) }
      let(:course_update) { attributes_for(:course) }
      let(:params) { { id: course.id, course: course_update } }

      context 'with valid params' do
        include_examples 'course_examples', :ok
      end

      xcontext 'without params' do
        let(:params) { {} }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "without id params" do
        let(:params) { { course: course_update } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "with invalid id params" do
        pending
        let(:params) { { id: Faker::Number.number(10), course: course_update } }
      end

      context 'with extra params next to course' do
        let(:params) { { id: course.id, course: course_update, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into course' do
        let(:params) do
          course_update[:extra] = 'this extra params'
          { id: course.id, course: course_update }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without course params" do
        it {
          params.delete(:course)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without course:title" do
        let(:course_update) { attributes_for(:course).except!(:title) }

        include_examples 'course_examples', :ok
      end

      context "without course:description" do
        let(:course_update) { attributes_for(:course).except!(:description) }

        include_examples 'course_examples', :ok
      end

      context "with invalid course:title:nil" do
        it {
          course_update[:title] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid course:title:too_long" do
        it {
          course_update[:title] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid course:description:nil" do
        it {
          course_update[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid course:description:too_long" do
        it {
          course_update[:description] = Faker::Lorem.characters(350)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid course params" do
        it {
          course_update[:title] = Faker::Lorem.characters(55)
          course_update[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe "DELETE #destroy" do
      subject(:course_request) { delete :destroy, params: params }

      let(:course) { create(:course, creator: test_user) }
      let(:params) { { id: course.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:no_content) }
        it 'delete in db' do
          course
          expect{ course_request }.to change(Course, :count).by(-1)
        end
      end

      xcontext "with invalid id" do
        let(:params) { { id: Faker::Number.number(10) } }
        # Controller To be changed to forbidden

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "with extra params" do
        let(:params) { { id: course.id, extra: 'extra params' } }

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

      let(:course) { create(:course) }
      let(:course_update) { attributes_for(:course) }
      let(:params) { { id: course.id, course: course_update } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context 'with extra params next to course' do
        let(:params) { { id: course.id, course: course_update, extra: 'this extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:course) { create(:course) }
      let(:params) { { id: course.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context "with extra params" do
        let(:params) { { id: course.id, extra: 'extra params' } }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end

  # Without authenticated user

  context 'without auth user' do
    describe "GET #index" do
      subject { get :index }

      course_count = 5
      let(:courses) { create_list(:course, course_count) }

      context 'with valid request' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'GET #show' do
      subject { get :show, params: params }

      let(:course) { create(:course) }
      let(:params) { { id: course.id } }

      context 'with :id exists' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'POST #create' do
      subject { post :create, params: params }

      let(:course) { attributes_for(:course) }
      let(:params) { { course: course } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'patch #update' do
      subject { patch :update, params: params }

      let(:course) { create(:course) }
      let(:course_update) { attributes_for(:course) }
      let(:params) { { id: course.id, course: course_update } }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:course) { create(:course) }
      let(:params) { { id: course.id } }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
end
