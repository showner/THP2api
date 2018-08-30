module V1
  class CoursesController < ApplicationController
    before_action :authenticate_v1_user!
    before_action do
      @attributes = %i[title description]
      @allow_only_params_for = {
        create:  [course: @attributes],
        destroy: [:id],
        index:   [],
        show:    [:id],
        update:  [:id, course: @attributes]
      }
      deny_all_unpermitted_parameters
    end
    before_action :find_course, only: %i[show update destroy]

    def index
      render json: Course.all
    end

    def show
      render json: @course
      # render json: CourseSerializer.new(course).serializable_hash[:data][:attributes]
    end

    def create
      course = Course.create!(create_params.merge(creator: current_v1_user))
      render json: course, status: :created
    end

    def update
      authorize [:v1, @course]
      @course.update!(update_params)
      render json: @course
    end

    def destroy
      authorize [:v1, @course]
      @course.destroy
      head :no_content
    end

    private

    def create_params
      params.require(:course).permit(@attributes)
    end
    alias_method :update_params, :create_params

    def find_course
      @course = Course.find(params[:id])
    end
  end
end
