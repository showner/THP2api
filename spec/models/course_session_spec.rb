# == Schema Information
#
# Table name: course_sessions
#
#  id            :uuid             not null, primary key
#  ending_date   :datetime
#  name          :string(50)
#  starting_date :datetime         not null
#  student_max   :integer          not null
#  student_min   :integer          default(2), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  course_id     :uuid
#
# Indexes
#
#  index_course_sessions_on_course_id  (course_id)
#
# Foreign Keys
#
#  fk_rails_...  (course_id => courses.id)
#

RSpec.describe CourseSession, type: :model do
  describe '#validator' do
    context 'factory is valid' do
      subject { create(:course_session) }
      it { is_expected.to be_valid }
      it { expect{ subject }.to change{ CourseSession.count }.by(1) }
    end

    context ':ending_date' do
      subject { create(:course_session) }
      it { expect(subject.attributes.with_indifferent_access).to include(:ending_date) }
      it { expect(subject.type_for_attribute(:ending_date).type).to eq :datetime }
    end

    context ':name' do
      it { is_expected.to validate_length_of(:name).is_at_most(50) }
    end

    context ':starting_date' do
      subject { create(:course_session) }
      it { expect(subject.attributes.with_indifferent_access).to include(:starting_date) }
      it { expect(subject.type_for_attribute(:starting_date).type).to eq :datetime }
    end

    context ':student_max' do
      subject { create(:course_session) }
      it { is_expected.to validate_numericality_of(:student_max).is_less_than(1000) }
      it { is_expected.to validate_numericality_of(:student_max).is_greater_than(subject.student_min) }
    end

    context ':student_min' do
      it { is_expected.to validate_numericality_of(:student_min).is_greater_than(1) }
    end

    context ':student_min on #update' do
      subject { create(:course_session) }
      it { is_expected.to validate_numericality_of(:student_min).is_less_than(subject.student_max).on(:update) }
    end

    context "with wrong dates" do
      it "shouldn't allow to start a course session in the past" do
        expect{ create(:course_session, :with_error_starting_in_past) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "shouldn't allow to end a course session in the past" do
        expect{ create(:course_session, :with_error_ending_in_past) }.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "shouldn't allow to end a course session before it starts" do
        expect{ create(:course_session, :with_error_ending_before_starting) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#scope' do
    context ':default_scope' do
      it { expect(CourseSession.all.default_scoped.to_sql).to eq CourseSession.all.to_sql }
    end
  end

  describe '#DbColumns' do
    context ':id' do
      it { is_expected.to have_db_column(:id).of_type(:uuid) }
      it { is_expected.to have_db_column(:id).with_options(primary_key: true, null: false) }
    end
    context ':ending_date' do
      it { is_expected.to have_db_column(:ending_date).of_type(:datetime) }
    end
    context ':name' do
      it { is_expected.to have_db_column(:name).of_type(:string) }
    end
    context ':starting_date' do
      it { is_expected.to have_db_column(:starting_date).of_type(:datetime) }
      it { is_expected.to have_db_column(:starting_date).with_options(null: false) }
    end
    context ':student_max' do
      it { is_expected.to have_db_column(:student_max).of_type(:integer) }
      it { is_expected.to have_db_column(:student_max).with_options(null: false) }
    end
    context ':student_min' do
      it { is_expected.to have_db_column(:student_min).of_type(:integer) }
      it { is_expected.to have_db_column(:student_min).with_options(default: 2, null: false) }
    end
    context ':created_at' do
      it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:created_at).with_options(null: false) }
    end
    context ':updated_at' do
      it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
      it { is_expected.to have_db_column(:updated_at).with_options(null: false) }
    end
    context ':course_id' do
      it { is_expected.to have_db_column(:course_id).of_type(:uuid) }
    end
  end

  describe '#DbIndex' do
    context ':index_course_sessions_on_course_id' do
      it { is_expected.to have_db_index(:course_id) }
    end
  end

  describe '#relationship' do
    let!(:user) { create(:user) }
    let!(:course) { create(:course, creator: user) }
    subject { create(:course_session, course: course) }
    let(:course_session) { create(:course_session) }
    context 'course_session belongs_to course' do
      it { is_expected.to belong_to(:course).inverse_of(:sessions) }
      it { is_expected.to belong_to(:course).counter_cache(:sessions_count) }
    end
    context 'increment sessions_count by 1' do
      it { expect{ subject }.to change{ Course.last.sessions_count }.by(1) }
    end
    context 'follows course_session link through course' do
      it 'course_session should eq course_session' do
        expect(course_session.course.sessions.last).to eq(course_session)
      end
    end
  end

  describe "#Serialization" do
    let(:course_session) { create(:course_session) }
    subject(:serializer) { CourseSessionSerializer.new(course_session) }
    it { is_expected.to respond_to(:serializable_hash) }
    context 'course_session serializer' do
      it { expect(subject.serializable_hash).to have_key(:id) }
      it { expect(subject.serializable_hash).to have_key(:ending_date) }
      it { expect(subject.serializable_hash).to have_key(:name) }
      it { expect(subject.serializable_hash).to have_key(:starting_date) }
      it { expect(subject.serializable_hash).to have_key(:student_max) }
      it { expect(subject.serializable_hash).to have_key(:student_min) }
      it { expect(subject.serializable_hash).to have_key(:created_at) }
      it { expect(subject.serializable_hash).to have_key(:updated_at) }
      it { expect(subject.serializable_hash).to have_key(:course_id) }
    end
  end
end
