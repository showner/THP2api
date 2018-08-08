RSpec.describe V1::CoursesController, type: :routing do
  describe "GET #index" do
    context "routes to index" do
      subject { get 'v1/courses' }
      it { is_expected.to be_routable }
    end
  end

  describe "GET #show" do
    context "routes to show" do
      let(:request) { get 'v1/courses/' + 'fake_id' }
      subject { request }
      it { is_expected.to be_routable }
    end
  end

  describe "POST #create" do
    context "routes to create" do
      subject { post 'v1/courses' }
      it { is_expected.to be_routable }
    end
  end

  describe "PATCH #update" do
    context "routes to update" do
      subject { patch 'v1/courses/' + 'fake_id' }
      it { is_expected.to be_routable }
    end
  end

  describe "DELETE #destroy" do
    context "routes to destroy" do
      subject { delete 'v1/courses/' + 'fake_id' }
      it { is_expected.to be_routable }
    end
  end
end
