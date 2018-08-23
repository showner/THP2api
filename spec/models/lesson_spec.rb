# == Schema Information
#
# Table name: lessons
#
#  id          :uuid             not null, primary key
#  description :text             not null
#  title       :string(50)       not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  course_id   :uuid
#  creator_id  :uuid
#
# Indexes
#
#  index_lessons_on_course_id   (course_id)
#  index_lessons_on_creator_id  (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#  fk_rails_...  (creator_id => users.id)
#

RSpec.describe Lesson, type: :model do
  describe '#validator' do
    context 'when factory is valid' do
      subject(:lesson) { create(:lesson) }

      it { is_expected.to be_valid }
      it { expect{ lesson }.to change(Lesson, :count).by(1) }
    end

    context 'with :title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(50) }
    end

    context 'with :description' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_length_of(:description).is_at_most(300) }
    end

    context 'with :course' do
      it { is_expected.to validate_presence_of(:course) }
    end
  end

  describe '#scope' do
    context 'with :default_scope' do
      it { expect(Lesson.all.default_scoped.to_sql).to eq Lesson.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context 'with :id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end

    context 'with :description' do
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:description).with_options(null: false) }
    end

    context 'with :title' do
      it { is_expected.to have_db_column(:title).of_type(:string) }
      it { is_expected.to have_db_column(:title).with_options(limit: 50, null: false) }
    end

    context 'with :created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end

    context 'with :updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end

    context 'with :course_id' do
      it { is_expected.to have_db_column(:course_id).of_type(:uuid) }
    end

    context 'with :creator_id' do
      it { is_expected.to have_db_column(:creator_id).of_type(:uuid) }
    end
  end

  describe '#DbIndex' do
    context 'with :index_lessons_on_course_id' do
      it { is_expected.to have_db_index(:course_id) }
    end

    context 'with :index_lessons_on_creator_id' do
      it { is_expected.to have_db_index(:creator_id) }
    end
  end

  describe '#relationship' do
    subject(:sub_lesson) { create(:lesson, course: course) }

    let!(:user) { create(:user) }
    let!(:course) { create(:course, creator: user) }
    let(:lesson) { create(:lesson) }

    context 'with lesson belongs_to user' do
      it { is_expected.to belong_to(:creator).class_name(:User) }
      it { is_expected.to belong_to(:creator).inverse_of(:created_lessons) }
      it { is_expected.to belong_to(:creator).counter_cache(:created_lessons_count) }
    end

    context 'with lesson belongs_to course' do
      it { is_expected.to belong_to(:course).counter_cache(true) }
    end

    context 'when increment created_lessons_count by 1' do
      it { expect{ sub_lesson }.to change{ User.last.created_lessons_count }.by(1) }
    end

    context 'when increment lessons_count by 1' do
      it { expect{ sub_lesson }.to change{ Course.last.lessons_count }.by(1) }
    end

    context 'when lesson link through creator' do
      it 'lesson should eq lesson' do
        expect(lesson.creator.created_lessons.last).to eq(lesson)
      end
    end

    context 'when lesson link through course' do
      it 'lesson should eq lesson' do
        expect(lesson.course.lessons.last).to eq(lesson)
      end
    end
  end

  describe "#Serialization" do
    subject(:serializer) { LessonSerializer.new(lesson) }

    let(:lesson) { create(:lesson) }

    it { is_expected.to respond_to(:serializable_hash) }
    context 'with lesson serializer' do
      it { expect(serializer.serializable_hash).to have_key(:id) }
      it { expect(serializer.serializable_hash).to have_key(:title) }
      it { expect(serializer.serializable_hash).to have_key(:description) }
      it { expect(serializer.serializable_hash).to have_key(:created_at) }
      it { expect(serializer.serializable_hash).to have_key(:updated_at) }
      it { expect(serializer.serializable_hash).to have_key(:creator_id) }
      it { expect(serializer.serializable_hash).to have_key(:course_id) }
    end
  end
end
