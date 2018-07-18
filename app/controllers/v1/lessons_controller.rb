module V1
  class LessonsController < ApplicationController
    def index
      lessons = Lesson.all
      render json: lessons
    end

    def show
      lesson = Lesson.find(params[:id])
      render json: lesson
      # render json: LessonSerializer.new(lesson).serializable_hash[:data][:attributes]
    end

    def create
      lesson = Lesson.create!(create_params)
      render json: lesson, status: :created
    end

    def update
      lesson = Lesson.find(params[:id])
      lesson.update!(update_params)
      render json: lesson
    end

    def destroy
      # Maybe destroy, see later
      # Lesson.find(params[:id]).destroy
      Lesson.find(params[:id]).delete
      head :no_content
    end

    private

    def create_params
      params.require(:lesson).permit(:title, :description)
    end
    alias_method :update_params, :create_params
  end
end
