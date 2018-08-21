RSpec.shared_examples 'organization_examples' do |parameter|
  it 'returns last organization' do
    subject
    organization = Organization.new(response_from_json)
    expect(organization).to eq Organization.last
  end
  it {
    is_expected.to have_http_status(parameter)
  }
  it 'returns json utf8' do
    is_expected.to be_json_utf8
  end
  it 'returns organization schema' do
    is_expected.to match_response_schema('organization')
  end
  xit 'returns valid organization object' do
    pending
    subject
    organization = Organization.new(response_from_json)
    expect(organization).to be_valid
  end
  it 'returns valid id' do
    subject
    expect(response_from_json).to have_key(:id)
    expect(response_from_json[:id]).not_to be_blank
    expect(response_from_json[:id]).to be_valid_uuid
  end
  it 'returns valid timestamps' do
    subject
    expect(response_from_json).to have_key(:created_at)
    expect(response_from_json).to have_key(:updated_at)
    expect(response_from_json[:created_at]).to be_valid_date
    expect(response_from_json[:updated_at]).to be_valid_date
  end
end
