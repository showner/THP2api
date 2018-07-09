require 'rails_helper'

RSpec.describe V1::LessonsController, type: :controller do
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    let(:lesson) { create(:lesson) }
    it "returns http success" do
      pending
      get v1_lesson_path + lesson.id.to_s
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    include UuidSpecHelper
    let(:params) { build(:lesson) }
    subject! { post :create, params: { lesson: attributes_for(:lesson) } }
    # Showner way
    # it "returns http created" do
    #   post :create, params: { lesson: { title: lesson.title, decription: lesson.description } }
    #   expect(response).to have_http_status(:created)
    # end
    # Marv way
    it 'returns created status' do
      expect(response).to have_http_status(:created)
    end
    it 'returns json' do
      expect(response.header["Content-Type"].downcase).to eq('application/json; charset=utf-8')
    end
    it "returns valid Lesson object" do
      lesson = Lesson.new(response_from_json)
      expect(lesson).to be_valid
    end
    it "returns valid id" do
      expect(response_from_json["id"]).not_to be_blank
      expect(response_from_json["id"]).to be_valid_uuid
    end
    it "returns valid timestamps" do
      date_format = '%Y-%m-%dT%H:%M:%S.%L%z' # FIXME: get it from DB format
      expect {
        Date.strptime(response_from_json['created_at'], date_format)
      }.not_to raise_error # .not_to raise_error(ArgumentError)
      expect {
        Date.strptime(response_from_json['updated_at'], date_format)
      }.not_to raise_error
    end
  end

  describe "patch #update" do
    it "returns http success" do
      pending
      patch :update
      expect(response).to have_http_status(:ok)
    end
  end

  describe "DELETE #destroy" do
    it "returns http no-content" do
      pending
      delete :destroy
      expect(response).to have_http_status(:no_content)
    end
  end
end
