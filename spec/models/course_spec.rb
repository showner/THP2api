# == Schema Information
#
# Table name: courses
#
#  id            :uuid             not null, primary key
#  description   :text
#  lessons_count :integer          default(0)
#  title         :string(50)       not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  creator_id    :uuid
#
# Indexes
#
#  index_courses_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (creator_id => users.id)
#

require 'rails_helper'

RSpec.describe Course, type: :model do
  describe '#validator' do
    context 'factory is valid' do
      subject { create(:course) }
      it { is_expected.to be_valid }
      it { expect{ create(:course) }.to change{ Course.count }.by(1) }
    end

    context ':title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(50) }
    end

    context ':description' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_length_of(:description).is_at_most(300) }
    end
  end

  describe '#scope' do
    context ':default_scope' do
      it { expect(Course.all.default_scoped.to_sql).to eq Course.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context ':id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end
    context ':description' do
      it { is_expected.to have_db_column(:description).of_type(:text) }
    end
    context ':lessons_count' do
      it { is_expected.to have_db_column(:lessons_count).of_type(:integer) }
      it { is_expected.to have_db_column(:lessons_count).with_options(default: 0) }
    end
    context ':title' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:title).with_options(limit: 50, null: false) }
    end
    context ':created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end
    context ':updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end
    context ':creator_id' do
      it { is_expected.to have_db_column(:creator_id).of_type(:uuid) }
    end
  end

  describe '#DbIndex' do
    context ':index_courses_on_creator_id' do
      it { is_expected.to have_db_index(:creator_id) }
    end
  end

  describe '#relationship' do
    let!(:user) { create(:user) }
    let(:course) { create(:course) }
    subject { create(:course, creator: user) }
    let(:lesson) { create(:lesson, creator: course.creator, course: course) }
    context 'course belongs_to user' do
      it { is_expected.to belong_to(:creator).class_name(:User) }
      it { is_expected.to belong_to(:creator).inverse_of(:created_courses) }
      it { is_expected.to belong_to(:creator).counter_cache(:created_courses_count) }
    end
    context 'increment created_courses_count by 1' do
      it { expect{ subject }.to change{ User.last.created_courses_count }.by(1) }
    end
    context 'course has_many lessons' do
      it { is_expected.to have_many(:lessons).dependent(:destroy) }
    end
    context 'follows course link through creator' do
      it 'course should eq course' do
        lesson
        expect(course.creator.created_courses.last).to eq(course)
      end
    end
    context 'follows course link through lessons' do
      it 'course should eq course' do
        lesson
        expect(course.lessons.last.course).to eq(course)
      end
    end
  end
end
