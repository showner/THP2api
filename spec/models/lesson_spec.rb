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
  end

  it 'increment Lesson count' do
    expect{ create(:lesson) }.to change{ Lesson.count }.by(1)
  end

  describe(:title) do
    it { should_not be_blank }
  end

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(50) }
  it { should validate_length_of(:description).is_at_most(300) }
end
