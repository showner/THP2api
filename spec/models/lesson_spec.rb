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

require 'faker'

RSpec.describe Lesson, type: :model do
  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_most(50) }
  it { should validate_length_of(:description).is_at_most(300) }

  it 'is creatable and ' do
    lesson = create(:lesson)
    expect(Lesson.first.title).to eq(lesson.title)
  end

  it 'increment Lesson count' do
    expect{ create(:lesson) }.to change{ Lesson.count }.by(1)
  end
end
