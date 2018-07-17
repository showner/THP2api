require 'rails_helper'

RSpec.describe V1::LessonsController, type: :controller do
  describe "GET #index" do
    lesson_count = 5
    let!(:lessons) { create_list(:lesson, lesson_count) }
    subject { get :index }
    it 'returns http success' do
      subject
      expect(response).to have_http_status(:ok)
    end
    it "returns #{lesson_count} Lessons" do
      subject
      expect(response_from_json.size).to eq(lesson_count)
      expect(response_from_json.map{ |e| e["id"] }).to eq(lessons.map(&:id))
    end
    context 'with params' do
      subject { get :index, params: { another_params: Faker::Lorem.word } }
      it 'returns http success' do
        subject
        expect(response).to have_http_status(:ok)
      end
      it "returns #{lesson_count} Lessons" do
        subject
        expect(response_from_json.size).to eq(lesson_count)
        expect(response_from_json.map{ |e| e["id"] }).to eq(lessons.map(&:id))
      end
    end
  end

  describe 'GET #show' do
    let(:lesson) { create(:lesson) }
    subject { get :show, params: params }
    context ':id exists' do
      let(:params) { { id: lesson.id } }
      include_examples 'lesson_examples', :ok
    end
    context ":id doesn't exist" do
      let(:params) { { id: Faker::Lorem.word } }
      it 'returns 404 not_found' do
        subject
        expect(response).to have_http_status(:not_found)
      end
    end
    context "has extras params" do
      let(:params) { { id: lesson.id, another_params: Faker::Lorem.word } }
      include_examples 'lesson_examples', :ok
    end
  end

  describe 'POST #create' do
    subject { post :create, params: lesson }
    let(:lesson) { { lesson: params } }
    let(:params) { attributes_for(:lesson) }
    context 'with valid params' do
      include_examples 'lesson_examples', :created
    end
    context "without params" do
      it 'returns 403 forbidden' do
        lesson.delete(:lesson)
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
    context "without title" do
      it 'returns 403 forbidden' do
        params.delete(:title)
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
    context "without description" do
      it 'returns 403 forbidden' do
        params.delete(:description)
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
    context "with invalid title" do
      it ':nil returns 403 forbidden' do
        params[:title] = nil
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it ':too_long returns 403 forbidden' do
        params[:title] = Faker::Lorem.characters(55)
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
    context "with invalid description" do
      it ':nil returns 403 forbidden' do
        params[:description] = nil
        subject
        expect(response).to have_http_status(:forbidden)
      end
      it ':too_long returns 403 forbidden' do
        params[:description] = Faker::Lorem.characters(350)
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
    context "with invalid params" do
      it 'returns 403 forbidden' do
        params[:title] = Faker::Lorem.characters(55)
        params[:description] = nil
        subject
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'patch #update' do
    let(:lesson) { create(:lesson) }
    subject! { patch :update, params: { id: lesson.id, lesson: attributes_for(:lesson) } }
    include_examples 'lesson_examples', :ok
  end

  describe "DELETE #destroy" do
    let!(:lesson) { create(:lesson) }
    subject { delete :destroy, params: { id: lesson.id } }
    it 'returns http no-content' do
      subject
      expect(response).to have_http_status(:no_content)
    end
    it 'delete in db' do
      expect{ subject }.to change(Lesson, :count).by(-1)
    end
  end
end
