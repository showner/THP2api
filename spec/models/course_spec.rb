# == Schema Information
#
# Table name: courses
#
#  id             :uuid             not null, primary key
#  description    :text             not null
#  lessons_count  :integer          default(0)
#  sessions_count :integer          default(0)
#  title          :string(50)       not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  creator_id     :uuid
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
    context 'when factory is valid' do
      subject(:course) { create(:course) }

      it { is_expected.to be_valid }
      it { expect{ course }.to change( Course, :count).by(1) }
    end

    context 'with :title' do
      it { is_expected.to validate_presence_of(:title) }
      it { is_expected.to validate_length_of(:title).is_at_most(50) }
    end

    context 'with :description' do
      it { is_expected.to validate_presence_of(:description) }
      it { is_expected.to validate_length_of(:description).is_at_most(300) }
    end
  end

  describe '#scope' do
    context 'with :default_scope' do
      it { expect(Course.all.default_scoped.to_sql).to eq Course.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context 'with :id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end

    context 'with :sessions_count' do
      it { is_expected.to have_db_column(:sessions_count).of_type(:integer) }
      it { is_expected.to have_db_column(:sessions_count).with_options(default: 0) }
    end

    context 'with :description' do
      it { is_expected.to have_db_column(:description).of_type(:text) }
      it { is_expected.to have_db_column(:description).with_options(null: false) }
    end

    context 'with :lessons_count' do
      it { is_expected.to have_db_column(:lessons_count).of_type(:integer) }
      it { is_expected.to have_db_column(:lessons_count).with_options(default: 0) }
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

    context 'with :creator_id' do
      it { is_expected.to have_db_column(:creator_id).of_type(:uuid) }
    end
  end

  describe '#DbIndex' do
    context 'with :index_courses_on_creator_id' do
      it { is_expected.to have_db_index(:creator_id) }
    end
  end

  describe '#relationship' do
    subject(:sub_course) { create(:course, creator: user) }

    let!(:user) { create(:user) }
    let(:course) { create(:course) }

    context 'when course belongs_to user' do
      it { is_expected.to belong_to(:creator).class_name(:User) }
      it { is_expected.to belong_to(:creator).inverse_of(:created_courses) }
      it { is_expected.to belong_to(:creator).counter_cache(:created_courses_count) }
    end

    context 'when increment created_courses_count by 1' do
      it { expect{ sub_course }.to change{ User.last.created_courses_count }.by(1) }
    end

    context 'when course has_many lessons' do
      it { is_expected.to have_many(:lessons).dependent(:destroy) }
    end

    context 'when course has_many sessions' do
      it { is_expected.to have_many(:sessions).class_name(:CourseSession) }
      it { is_expected.to have_many(:sessions).dependent(:destroy) }
    end

    context 'when course has_many invitations' do
      it { is_expected.to have_many(:invitations).dependent(:destroy) }
    end
  end

  describe '#Follows' do
    let(:course) { create(:course) }
    let(:lesson) { create(:lesson, creator: course.creator, course: course) }
    let(:course_session) { create(:course_session, course: course) }

    context 'when course link through creator' do
      it 'course should eq course' do
        expect(course.creator.created_courses.last).to eq(course)
      end
    end

    context 'when course link through lessons' do
      it 'course should eq course' do
        lesson
        expect(course.lessons.last.course).to eq(course)
      end
    end

    context 'when course link through sessions' do
      it 'course should eq course' do
        course_session
        expect(course.sessions.last.course).to eq(course)
      end
    end
  end

  describe "#Serialization" do
    subject(:serializer) { CourseSerializer.new(course) }

    let(:course) { create(:course) }
    let(:lesson) { create(:lesson, course: course, creator: course.creator) }

    it { is_expected.to respond_to(:serializable_hash) }
    context 'with course serializer' do
      it { expect(serializer.serializable_hash).to have_key(:id) }
      it { expect(serializer.serializable_hash).to have_key(:title) }
      it { expect(serializer.serializable_hash).to have_key(:description) }
      it { expect(serializer.serializable_hash).to have_key(:created_at) }
      it { expect(serializer.serializable_hash).to have_key(:updated_at) }
      it { expect(serializer.serializable_hash).to have_key(:creator_id) }
      it { expect(serializer.serializable_hash).to have_key(:lessons_count) }
      it { expect(serializer.serializable_hash).to have_key(:lessons) }
    end

    context 'with course serializer' do
      it { expect(serializer.serializable_hash).not_to have_key(:sessions) }
      it { expect(serializer.serializable_hash).not_to have_key(:sessions_count) }
    end
  end
end
