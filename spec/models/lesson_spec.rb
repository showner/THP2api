# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  title       :string(50)       not null
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

RSpec.describe Lesson, type: :model do
  it 'is creatable' do
    lesson = create(:lesson)
    last_lesson = Lesson.last
    expect(last_lesson.title).to eq(lesson.title)
    expect(last_lesson.title).not_to be_blank
    expect(last_lesson.description).to eq(lesson.description)
    expect(last_lesson.description).not_to be_blank
  end

  context 'increment Lesson count' do
    it { expect{ create(:lesson) }.to change{ Lesson.count }.by(1) }
  end
  context ':title' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:title).is_at_most(50) }
  end
  context ':description' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_length_of(:description).is_at_most(300) }
  end
end
