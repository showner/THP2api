RSpec.shared_examples 'organization_examples' do |parameter|
  xit 'returns last organization' do
    organization_request
    # binding.pry
    organization = Organization.new(response_from_json_as('organization'))
    expect(organization).to eq Organization.last
  end

  it { is_expected.to have_http_status(parameter) }

  it 'returns json utf8' do
    is_expected.to be_json_utf8
  end

  it 'returns organization schema' do
    is_expected.to match_response_schema('organization')
  end

  xit 'returns valid organization object' do
    organization_request
    Organization.last.destroy
    response_from_json.delete(:members) if response_from_json.key?(:members)
    organization = Organization.new(response_from_json)
    expect(organization).to be_valid
  end

  context 'when returns valid id' do
    before { organization_request }

    it { expect(response_from_json_as('organization')).to have_key(:id) }
    it { expect(response_from_json_as('organization')[:id]).not_to be_blank }
    it { expect(response_from_json_as('organization')[:id]).to be_valid_uuid }
  end

  context 'when returns valid timestamps' do
    before { organization_request }

    it { expect(response_from_json_as('organization')).to have_key(:created_at) }
    it { expect(response_from_json_as('organization')).to have_key(:updated_at) }
    it { expect(response_from_json_as('organization')[:created_at]).to be_valid_date }
    it { expect(response_from_json_as('organization')[:updated_at]).to be_valid_date }
  end
end
