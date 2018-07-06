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

    expect(Lesson.last.title).to eq(lesson.title)
    expect(Lesson.last.title).not_to be_blank
    expect(Lesson.last.description).to eq(lesson.description)
    expect(Lesson.last.description).not_to be_blank
  end

  context 'increment Lesson count' do
    it { expect{ create(:lesson) }.to change{ Lesson.count }.by(1) }
  end
  context ':title' do
    it { expect(:title).to_not be_blank }
    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_most(50) }
  end
  context ':description' do
    it { should validate_length_of(:description).is_at_most(300) }
  end
end
