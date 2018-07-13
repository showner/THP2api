require 'rails_helper'

RSpec.describe V1::LessonsController, type: :controller do
  describe "GET #index" do
    lesson_count = 5
    before { create_list(:lesson, lesson_count) }
    before { get :index }
    it 'returns http success' do
      expect(response).to have_http_status(:ok)
    end
    it "returns #{lesson_count} Lessons" do
      expect(response_from_json.length).to eq(lesson_count)
    end
  end

  describe 'GET #show' do
    let(:lesson) { create(:lesson) }
    before { get :show, params: { id: lesson.id } }
    include_examples 'lesson_examples', :ok
  end

  describe 'POST #create' do
    before { post :create, params: { lesson: attributes_for(:lesson) } }
    include_examples 'lesson_examples', :created
  end

  describe 'patch #update' do
    let(:lesson) { create(:lesson) }
    before { patch :update, params: { id: lesson.id, lesson: attributes_for(:lesson) } }
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