RSpec.shared_examples 'course_examples' do |parameter|
  it 'returns last course' do
    course_request
    course = Course.new(response_from_json)
    expect(course).to eq Course.last
  end

  it {
    is_expected.to have_http_status(parameter)
  }

  it 'returns json utf8' do
    is_expected.to be_json_utf8
  end

  it 'returns course schema' do
    is_expected.to match_response_schema('course')
  end

  it 'returns valid Course object' do
    course_request
    course = Course.new(response_from_json)
    expect(course).to be_valid
  end

  context 'when returns valid id' do
    before { course_request }

    it { expect(response_from_json).to have_key(:id) }
    it { expect(response_from_json[:id]).not_to be_blank }
    it { expect(response_from_json[:id]).to be_valid_uuid }
  end

  context 'when returns valid timestamps' do
    before { course_request }

    it { expect(response_from_json).to have_key(:created_at) }
    it { expect(response_from_json).to have_key(:updated_at) }
    it { expect(response_from_json[:created_at]).to be_valid_date }
    it { expect(response_from_json[:updated_at]).to be_valid_date }
  end
end
