RSpec.shared_examples 'course_session_examples' do |parameter|
  it 'returns last course_session' do
    course_session_request
    course_session = CourseSession.new(response_from_json_as('course_session'))
    expect(course_session).to eq CourseSession.last
  end
  it {
    is_expected.to have_http_status(parameter)
  }
  it 'returns json utf8' do
    is_expected.to be_json_utf8
  end
  it 'returns course_session schema' do
    is_expected.to match_response_schema('course_session')
  end
  it 'returns valid CourseSession object' do
    course_session_request
    course_session = CourseSession.new(response_from_json_as('course_session'))
    expect(course_session).to be_valid
  end

  context 'when returns valid id' do
    before { course_session_request }

    it { expect(response_from_json_as('course_session')).to have_key(:id) }
    it { expect(response_from_json_as('course_session')[:id]).not_to be_blank }
    it { expect(response_from_json_as('course_session')[:id]).to be_valid_uuid }
  end

  context 'when returns valid timestamps' do
    before { course_session_request }

    it { expect(response_from_json_as('course_session')).to have_key(:created_at) }
    it { expect(response_from_json_as('course_session')).to have_key(:updated_at) }
    it { expect(response_from_json_as('course_session')[:created_at]).to be_valid_date }
    it { expect(response_from_json_as('course_session')[:updated_at]).to be_valid_date }
  end
end
