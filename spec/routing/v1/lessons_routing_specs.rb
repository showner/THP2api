RSpec.describe V1::LessonsController, type: :routing do
  describe "GET #index" do
    context "routes to index" do
      subject { get 'v1/lessons' }
      it { is_expected.to be_routable }
    end
  end

  describe "GET #show" do
    context "routes to show" do
      let(:request) { get 'v1/lessons/' + 'id' }
      subject { request }
      it { is_expected.to be_routable }
    end
  end

  describe "POST #create" do
    context "routes to create" do
      subject { post 'v1/lessons' }
      it { is_expected.to be_routable }
    end
  end

  describe "PATCH #update" do
    context "routes to update" do
      subject { patch 'v1/lessons/' + 'id' }
      it { is_expected.to be_routable }
    end
  end

  describe "DELETE #destroy" do
    context "routes to destroy" do
      subject { delete 'v1/lessons/' + 'id' }
      it { is_expected.to be_routable }
    end
  end
end
