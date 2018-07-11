RSpec.shared_examples 'lesson_examples' do |parameter|
  it 'returns last lesson' do
    lesson = Lesson.new(response_from_json)
    expect(lesson).to eq Lesson.last
  end
  it "returns #{parameter} http status" do
    expect(response).to have_http_status(parameter)
  end
  it 'returns json utf8' do
    expect(response).to be_json_utf8
  end
  it 'returns lesson schema' do
    expect(response).to match_response_schema('lesson')
  end
  it 'returns valid Lesson object' do
    lesson = Lesson.new(response_from_json)
    expect(lesson).to be_valid
  end
  it 'returns valid id' do
    expect(response_from_json).to have_key("id")
    expect(response_from_json["id"]).not_to be_blank
    expect(response_from_json["id"]).to be_valid_uuid
  end
  it 'returns valid title' do
    expect(response_from_json).to have_key("title")
    expect(response_from_json["title"]).not_to be_blank
    expect(response_from_json["title"].length).to be <= 50
  end
  it 'returns valid description' do
    expect(response_from_json).to have_key("description")
    expect(response_from_json["description"]).not_to be_blank
    expect(response_from_json["description"].length).to be <= 300
  end
  it 'returns valid timestamps' do
    expect(response_from_json).to have_key("created_at")
    expect(response_from_json).to have_key("updated_at")
    expect(response_from_json['created_at']).to be_valid_date
    expect(response_from_json['updated_at']).to be_valid_date
  end
end
