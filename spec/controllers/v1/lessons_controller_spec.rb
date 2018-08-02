require 'rails_helper'

RSpec.describe V1::LessonsController, type: :controller do
  # Without authenticated user
  context 'with auth user' do
    before(:each) {
      fake_user
    }
    describe "GET #index" do
      lesson_count = 5
      let!(:lessons) { create_list(:lesson, lesson_count) }
      subject { get :index }
      context 'with valid request'
      it { is_expected.to have_http_status(:ok) }
      it "returns #{lesson_count} Lessons" do
        subject
        expect(response_from_json.size).to eq(lesson_count)
        expect(response_from_json.map{ |e| e[:id] }).to eq(lessons.map(&:id))
      end

      context 'with extra params' do
        subject { get :index, params: { another_params: Faker::Lorem.word } }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'GET #show' do
      let(:lesson) { create(:lesson) }
      let(:params) { { id: lesson.id } }
      subject { get :show, params: params }

      context ':id exists' do
        include_examples 'lesson_examples', :ok
      end

      context ":id is not valid " do
        let(:params) { { id: Faker::Lorem.word } }
        it { is_expected.to have_http_status(:not_found) }
      end

      context "has extras params" do
        let(:params) { { id: lesson.id, another_params: Faker::Lorem.word } }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe 'POST #create' do
      let(:course) { create(:course, creator: test_user) }
      let(:lesson) { attributes_for(:lesson) }
      let(:params) { { lesson: lesson, course_id: course.id } }
      subject { post :create, params: params }

      context 'with valid params' do
        include_examples 'lesson_examples', :created
      end

      context 'with extra params next to lesson' do
        let(:params) { { lesson: lesson, extra: 'this extra params' } }
        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into lesson' do
        let(:params) do
          lesson[:extra] = 'this extra params'
          { lesson: lesson }
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
      let(:lesson) { create(:lesson, creator: test_user) }
      let(:lesson_update) { attributes_for(:lesson) }
      let(:params) { { id: lesson.id, lesson: lesson_update } }
      subject { patch :update, params: params }

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
        let(:params) { { id: Faker::Number.number(10), lesson: lesson_update } }
      end

      context 'with extra params next to lesson' do
        let(:params) { { id: lesson.id, lesson: lesson_update, extra: 'this extra params' } }
        it { is_expected.to have_http_status(:forbidden) }
      end

      context 'with extra params into lesson' do
        let(:params) do
          lesson_update[:extra] = 'this extra params'
          { id: lesson.id, lesson: lesson_update }
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
      context "with invalid lesson:title:nil" do
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
      let(:lesson) { create(:lesson, creator: test_user) }
      let(:params) { { id: lesson.id } }
      subject { delete :destroy, params: params }
      context "with valid id" do
        it { is_expected.to have_http_status(:no_content) }
        it 'delete in db' do
          lesson
          expect{ subject }.to change(Lesson, :count).by(-1)
        end
      end

      xcontext "with invalid id" do
        let(:params) { { id: Faker::Number.number(10) } }
        # Controller To be changed to forbidden
        it { is_expected.to have_http_status(:forbidden) }
      end

      context "with extra params" do
        let(:params) { { id: lesson.id, extra: 'extra params' } }
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
  # Creator != logged user
  context 'with other auth user' do
    before(:each) {
      fake_user
    }
    describe 'patch #update' do
      let(:lesson) { create(:lesson) }
      let(:lesson_update) { attributes_for(:lesson) }
      let(:params) { { id: lesson.id, lesson: lesson_update } }
      subject { patch :update, params: params }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
      context 'with extra params next to lesson' do
        let(:params) { { id: lesson.id, lesson: lesson_update, extra: 'this extra params' } }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end

    describe "DELETE #destroy" do
      let!(:lesson) { create(:lesson) }
      let(:params) { { id: lesson.id } }
      subject { delete :destroy, params: params }
      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end

      context "with extra params" do
        let(:params) { { id: lesson.id, extra: 'extra params' } }
        it { is_expected.to have_http_status(:forbidden) }
      end
    end
  end
  # Without authenticated user
  context 'without auth user' do
    describe "GET #index" do
      lesson_count = 5
      let!(:lessons) { create_list(:lesson, lesson_count) }
      subject { get :index }
      context 'with valid request' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'GET #show' do
      let(:lesson) { create(:lesson) }
      let(:params) { { id: lesson.id } }
      subject { get :show, params: params }

      context ":id exists " do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'POST #create' do
      let(:lesson) { attributes_for(:lesson) }
      let(:params) { { lesson: lesson } }
      subject { post :create, params: params }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe 'patch #update' do
      let(:lesson) { create(:lesson) }
      let(:lesson_update) { attributes_for(:lesson) }
      let(:params) { { id: lesson.id, lesson: lesson_update } }
      subject { patch :update, params: params }

      context 'with valid params' do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end

    describe "DELETE #destroy" do
      let!(:lesson) { create(:lesson) }
      let(:params) { { id: lesson.id } }
      subject { delete :destroy, params: params }
      context "with valid id" do
        it { is_expected.to have_http_status(:unauthorized) }
      end
    end
  end
end
