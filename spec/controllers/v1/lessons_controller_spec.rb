require 'rails_helper'

RSpec.describe V1::LessonsController, type: :controller do
  describe "GET #index" do
    lesson_count = 5
    let!(:lessons) { create_list(:lesson, lesson_count) }
    subject { get :index }

    it 'returns http success' do
      is_expected.to have_http_status(:ok)
    end

    it "returns #{lesson_count} Lessons" do
      subject
      expect(response_from_json.size).to eq(lesson_count)
      expect(response_from_json.map{ |e| e[:id] }).to eq(lessons.map(&:id))
    end

    context 'with extra params' do
      subject { get :index, params: { another_params: Faker::Lorem.word } }
      it 'returns http success' do
        is_expected.to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET #show' do
    let(:lesson) { create(:lesson) }
    let(:params) { { id: lesson.id } }
    subject { get :show, params: params }

    context ':id exists' do
      include_examples 'lesson_examples', :ok
    end

    context ":id doesn't exist" do
      let(:params) { { id: Faker::Lorem.word } }
      it 'returns 404 not_found' do
        is_expected.to have_http_status(:not_found)
      end
    end

    context "has extras params" do
      let(:params) { { id: lesson.id, another_params: Faker::Lorem.word } }
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST #create' do
    let(:lesson) { attributes_for(:lesson) }
    let(:params) { { lesson: lesson } }
    subject { post :create, params: params }

    context 'with valid params' do
      include_examples 'lesson_examples', :created
    end

    context 'with extra params next to lesson' do
      let(:params) { { lesson: lesson, extra: 'this extra params' } }
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end

    context 'with extra params into lesson' do
      let(:params) do
        lesson[:extra] = 'this extra params'
        { lesson: lesson }
      end
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "without params" do
      it 'returns 403 forbidden' do
        params.delete(:lesson)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "without title" do
      it 'returns 403 forbidden' do
        lesson.delete(:title)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "without description" do
      it 'returns 403 forbidden' do
        lesson.delete(:description)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "with invalid title" do
      it ':nil returns 403 forbidden' do
        lesson[:title] = nil
        is_expected.to have_http_status(:forbidden)
      end
      it ':too_long returns 403 forbidden' do
        lesson[:title] = Faker::Lorem.characters(55)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "with invalid description" do
      it ':nil returns 403 forbidden' do
        lesson[:description] = nil
        is_expected.to have_http_status(:forbidden)
      end
      it ':too_long returns 403 forbidden' do
        lesson[:description] = Faker::Lorem.characters(350)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "with invalid params" do
      it 'invalid and 403' do
        lesson[:title] = Faker::Lorem.characters(55)
        lesson[:description] = nil
        is_expected.to have_http_status(:forbidden)
      end
    end
  end

  describe 'patch #update' do
    let(:lesson) { create(:lesson) }
    let(:lesson_update) { attributes_for(:lesson) }
    let(:params) { { id: lesson.id, lesson: lesson_update } }
    subject { patch :update, params: params }

    context 'with valid params' do
      include_examples 'lesson_examples', :ok
    end

    xcontext 'without params' do
      let(:params) {}
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end

    xcontext "without id params" do
      let(:params) { { lesson: lesson_update } }
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "with invalid id params" do
      let(:params) { { id: Faker::Number.number(10), lesson: lesson_update } }
    end

    context 'with extra params next to lesson' do
      let(:params) { { id: lesson.id, lesson: lesson_update, extra: 'this extra params' } }
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end

    context 'with extra params into lesson' do
      let(:params) do
        lesson_update[:extra] = 'this extra params'
        { id: lesson.id, lesson: lesson_update }
      end
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "without lesson params" do
      it 'returns 403 forbidden' do
        params.delete(:lesson)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "without lesson:title" do
      let(:lesson_update) { attributes_for(:lesson).except!(:title) }
      include_examples 'lesson_examples', :ok
    end

    context "without lesson:description" do
      let(:lesson_update) { attributes_for(:lesson).except!(:description) }
      include_examples 'lesson_examples', :ok
    end

    context "with invalid lesson:title" do
      it ':nil returns 403 forbidden' do
        lesson_update[:title] = nil
        is_expected.to have_http_status(:forbidden)
      end
      it ':too_long returns 403 forbidden' do
        lesson_update[:title] = Faker::Lorem.characters(55)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "with invalid lesson:description" do
      it ':nil returns 403 forbidden' do
        lesson_update[:description] = nil
        is_expected.to have_http_status(:forbidden)
      end
      it ':too_long returns 403 forbidden' do
        lesson_update[:description] = Faker::Lorem.characters(350)
        is_expected.to have_http_status(:forbidden)
      end
    end

    context "with invalid lesson params" do
      it 'invalid and 403' do
        lesson_update[:title] = Faker::Lorem.characters(55)
        lesson_update[:description] = nil
        is_expected.to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE #destroy" do
    let!(:lesson) { create(:lesson) }
    let(:params) { { id: lesson.id } }
    subject { delete :destroy, params: params }
    context "with valid id" do
      it 'returns http no-content' do
        is_expected.to have_http_status(:no_content)
      end
      it 'delete in db' do
        expect{ subject }.to change(Lesson, :count).by(-1)
      end
    end

    context "with invalid id" do
      let(:params) { { id: Faker::Number.number(10) } }
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:not_found)
      end
    end

    context "with extra params" do
      let(:params) { { id: lesson.id, extra: 'extra params' } }
      it 'returns 403 forbidden' do
        is_expected.to have_http_status(:forbidden)
      end
    end

    xcontext "without params" do
      let(:params) {}
    end

    xcontext "only with extra params" do
      let(:params) { { extra: 'extra params' } }
    end
  end
end
