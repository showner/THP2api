RSpec.shared_examples 'invitation_examples' do |parameter|
  it 'returns last invitation' do
    # binding.pry
    invitation_request
    invitation = Invitation.new(response_from_json_as('invitation'))
    expect(invitation).to eq Invitation.last
  end

  it {
    is_expected.to have_http_status(parameter)
  }

  it 'returns json utf8' do
    is_expected.to be_json_utf8
  end

  it 'returns invitation schema' do
    is_expected.to match_response_schema('invitation')
  end

  it 'returns valid Invitation object' do
    invitation_request
    invitation = Invitation.new(response_from_json_as('invitation'))
    expect(invitation).to be_valid
  end

  context 'when returns valid id' do
    before { invitation_request }

    it { expect(response_from_json_as('invitation')).to have_key(:id) }
    it { expect(response_from_json_as('invitation')[:id]).not_to be_blank }
    it { expect(response_from_json_as('invitation')[:id]).to be_valid_uuid }
  end

  context 'when returns valid timestamps' do
    before { invitation_request }

    it { expect(response_from_json_as('invitation')).to have_key(:created_at) }
    it { expect(response_from_json_as('invitation')).to have_key(:updated_at) }
    it { expect(response_from_json_as('invitation')[:created_at]).to be_valid_date }
    it { expect(response_from_json_as('invitation')[:updated_at]).to be_valid_date }
  end
end
