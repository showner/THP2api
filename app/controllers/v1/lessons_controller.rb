module V1
  class LessonsController < ApplicationController
    before_action :authenticate_v1_user!
    before_action do
      @attributes = %i[title description]
      @allow_only_params_for = {
        create:  [:course_id, lesson: @attributes],
        destroy: %i[course_id id],
        index:   [:course_id],
        show:    %i[course_id id],
        update:  [:course_id, :id, lesson: @attributes]
      }
      deny_all_unpermitted_parameters
    end
    before_action :find_lesson, only: %i[show update destroy]
    before_action :current_course, only: %i[create index]

    def index
      render json: current_course.lessons
    end

    def show
      render json: @lesson
      # render json: LessonSerializer.new(lesson).serializable_hash[:data][:attributes]
    end

    def create
      # Choose between oneof the 2 way to write instruction (create or update)
      # lesson = current_v1_user.created_lessons.create!(create_params)
      lesson = Lesson.create!(create_params.merge(creator: current_v1_user, course: current_course))
      render json: lesson, status: :created
    end

    def update
      authorize [:v1, @lesson]
      @lesson.update!(update_params)
      render json: @lesson
    end

    def destroy
      authorize [:v1, @lesson]
      @lesson.destroy
      head :no_content
    end

    private

    def create_params
      params.require(:lesson).permit(@attributes)
    end
    alias_method :update_params, :create_params

    def current_course
      Course.find(params[:course_id])
    end

    def find_lesson
      @lesson = Lesson.find(params[:id])
    end
  end
end
