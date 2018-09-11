require 'rails_helper'

RSpec.describe V1::LessonsController, type: :controller do
  # With authenticated user
  context 'with auth user' do
    before { fake_user }

    let(:course) { create(:course) }
    let(:course_params) { { course_id: course.id } }
    let(:params) { course_params }

    describe "GET #index" do
      subject(:lesson_request) { get :index, params: params }

      before { create_list(:lesson, 8, course: course) }

      let(:lessons_page_one) { Lesson.order(created_at: :asc).limit(5) }

      context 'with valid request' do
        it { is_expected.to have_http_status(:ok) }
        it "returns 5 Lessons" do
          lesson_request
          expect(response_from_json_as('lessons').size).to eq(5)
        end
        it "returns the 5 Lessons" do
          lesson_request
          expect(response_from_json_as('lessons').map{ |e| e[:id] }).to eq(lessons_page_one.map(&:id))
        end
      end

      context 'with extra params' do
        subject { get :index, params: params.merge(another_params: Faker::Lorem.word) }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'GET #show' do
      subject(:lesson_request) { get :show, params: params }

      let(:lesson) { create(:lesson, course: course) }
      let(:lesson_params) { { id: lesson.id } }
      let(:params) { course_params.merge(lesson_params) }

      context 'with :id exists' do
        include_examples 'lesson_examples', :ok
      end

      context 'with :id is not valid' do
        let(:params) { course_params.merge(id: Faker::Lorem.word) }

        it { is_expected.to have_http_status(:not_found) }
      end

      context 'when has extras params' do
        let(:params) { course_params.merge(id: lesson.id, another_params: Faker::Lorem.word) }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'POST #create' do
      subject(:lesson_request) { post :create, params: params }

      let(:course) { create(:course, creator: test_user) }
      let(:lesson) { attributes_for(:lesson) }
      let(:params) { { lesson: lesson, course_id: course.id } }

      context 'with valid params' do
        include_examples 'lesson_examples', :created
      end

      context 'with extra params next to lesson' do
        let(:params) { course_params.merge(lesson: lesson, extra: 'this extra params') }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into lesson' do
        let(:params) do
          { course_id: course.id, lesson: lesson.merge(extra: 'this extra params') }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without params" do
        it {
          params.delete(:lesson)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without title" do
        it {
          lesson.delete(:title)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without description" do
        it {
          lesson.delete(:description)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid title:nil" do
        it {
          lesson[:title] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid title:too_long" do
        it {
          lesson[:title] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid description:nil" do
        it {
          lesson[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid description:too_long" do
        it {
          lesson[:description] = Faker::Lorem.characters(350)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid params" do
        it {
          lesson[:title] = Faker::Lorem.characters(55)
          lesson[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe 'patch #update' do
      subject(:lesson_request) { patch :update, params: params }

      let(:lesson) { create(:lesson, creator: test_user) }
      let(:lesson_update) { attributes_for(:lesson) }
      let(:params) { course_params.merge(id: lesson.id, lesson: lesson_update) }

      context 'with valid params' do
        include_examples 'lesson_examples', :ok
      end

      xcontext 'without params' do
        let(:params) { {} }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "without id params" do
        let(:params) { { lesson: lesson_update } }

        it { is_expected.to have_http_status(:forbidden) }
      end

      xcontext "with invalid id params" do
        pending
        let(:params) { { id: Faker::Number.number(10), lesson: lesson_update } }
      end

      context 'with extra params next to lesson' do
        let(:params) { course_params.merge(id: lesson.id, lesson: lesson_update, extra: 'this extra params') }

        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into lesson' do
        let(:params) do
          { course_id: course.id, id: lesson.id, lesson: lesson_update.merge(extra: 'this extra params') }
        end

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "without lesson params" do
        it {
          params.delete(:lesson)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "without lesson:title" do
        let(:lesson_update) { attributes_for(:lesson).except!(:title) }

        include_examples 'lesson_examples', :ok
      end

      context "without lesson:description" do
        let(:lesson_update) { attributes_for(:lesson).except!(:description) }

        include_examples 'lesson_examples', :ok
      end

      context "with invalid lesson:title:nil" do
        it {
          lesson_update[:title] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid lesson:title:too_long" do
        it {
          lesson_update[:title] = Faker::Lorem.characters(55)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid lesson:description:nil" do
        it {
          lesson_update[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid lesson:description:too_long" do
        it {
          lesson_update[:description] = Faker::Lorem.characters(350)
          is_expected.to have_http_status(:forbidden)
        }
      end

      context "with invalid lesson params" do
        it {
          lesson_update[:title] = Faker::Lorem.characters(55)
          lesson_update[:description] = nil
          is_expected.to have_http_status(:forbidden)
        }
      end
    end

    describe "DELETE #destroy" do
      subject(:lesson_request) { delete :destroy, params: params }

      let(:lesson) { create(:lesson, creator: test_user) }
      let(:params) { course_params.merge(id: lesson.id) }

      context "with valid id" do
        it { is_expected.to have_http_status(:no_content) }
        it 'delete in db' do
          lesson
          expect{ lesson_request }.to change(Lesson, :count).by(-1)
        end
      end

      xcontext "with invalid id" do
        let(:params) { { id: Faker::Number.number(10) } }

        # Controller To be changed to forbidden

        it { is_expected.to have_http_status(:forbidden) }
      end

      context "with extra params" do
        let(:params) { course_params.merge(id: lesson.id, extra: 'extra params') }

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

    let(:course) { create(:course) }
    let(:course_params) { { course_id: course.id } }
    let(:params) { course_params }

    describe 'patch #update' do
      subject { patch :update, params: params }

      let(:lesson) { create(:lesson) }
      let(:lesson_update) { attributes_for(:lesson) }
      let(:params) { course_params.merge(id: lesson.id, lesson: lesson_update) }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context 'with extra params next to lesson' do
        let(:params) { course_params.merge(id: lesson.id, lesson: lesson_update, extra: 'this extra params') }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:lesson) { create(:lesson) }
      let(:params) { course_params.merge(id: lesson.id) }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context "with extra params" do
        let(:params) { course_params.merge(id: lesson.id, extra: 'extra params') }

        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end

  # Without authenticated user

  context 'without auth user' do
    # creating course for routing
    let(:course) { create(:course) }
    let(:course_params) { { course_id: course.id } }
    let(:params) { course_params }

    describe "GET #index" do
      subject { get :index, params: course_params }

      lesson_count = 5
      let(:lessons) { create_list(:lesson, lesson_count) }

      context 'with valid request' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'GET #show' do
      subject { get :show, params: params }

      let(:lesson) { create(:lesson) }
      let(:params) { course_params.merge(id: lesson.id) }

      context 'with :id exists' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'POST #create' do
      subject { post :create, params: params }

      let(:lesson) { attributes_for(:lesson) }
      let(:params) { course_params.merge(lesson: lesson) }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'patch #update' do
      subject { patch :update, params: params }

      let(:lesson) { create(:lesson) }
      let(:lesson_update) { attributes_for(:lesson) }
      let(:params) { course_params.merge(id: lesson.id, lesson: lesson_update) }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: params }

      let!(:lesson) { create(:lesson) }
      let(:params) { course_params.merge(id: lesson.id) }

      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
end
