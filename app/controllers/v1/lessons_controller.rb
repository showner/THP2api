module V1
  class LessonsController < ApplicationController
    before_action :find_lesson, only: %i[show update destroy]

    def index
      lessons = Lesson.all
      render json: lessons
    end

    def show
      render json: @lesson
      # render json: LessonSerializer.new(lesson).serializable_hash[:data][:attributes]
    end

    def create
      lesson = Lesson.create!(create_params)
      render json: lesson, status: :created
    end

    def update
      # binding.pry
      @lesson.update!(update_params)
      render json: @lesson
    end

    def destroy
      # Maybe destroy, see later
      # Lesson.find(params[:id]).destroy
      @lesson.delete
      head :no_content
    end

    private

    def create_params
      ActionController::Parameters.action_on_unpermitted_parameters = :raise
      params.require(:lesson).permit(:title, :description)
    end
    alias_method :update_params, :create_params

    def find_lesson
      @lesson = Lesson.find(params[:id])
    end
  end
end
