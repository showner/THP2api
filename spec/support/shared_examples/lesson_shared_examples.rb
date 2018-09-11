RSpec.shared_examples 'lesson_examples' do |parameter|
  it 'returns last lesson' do
    lesson_request
    lesson = Lesson.new(response_from_json_as('lesson'))
    expect(lesson).to eq Lesson.last
  end

  it { is_expected.to have_http_status(parameter) }

  it 'returns json utf8' do
    is_expected.to be_json_utf8
  end

  it 'returns lesson schema' do
    # binding.pry
    is_expected.to match_response_schema('lesson')
  end

  it 'returns valid Lesson object' do
    lesson_request
    lesson = Lesson.new(response_from_json_as('lesson'))
    expect(lesson).to be_valid
  end

  context 'when returns valid id' do
    before { lesson_request }

    it { expect(response_from_json_as('lesson')).to have_key(:id) }
    it { expect(response_from_json_as('lesson')[:id]).not_to be_blank }
    it { expect(response_from_json_as('lesson')[:id]).to be_valid_uuid }
  end

  context 'when returns valid timestamps' do
    before { lesson_request }

    it { expect(response_from_json_as('lesson')).to have_key(:created_at) }
    it { expect(response_from_json_as('lesson')).to have_key(:updated_at) }
    it { expect(response_from_json_as('lesson')[:created_at]).to be_valid_date }
    it { expect(response_from_json_as('lesson')[:updated_at]).to be_valid_date }
  end
end
