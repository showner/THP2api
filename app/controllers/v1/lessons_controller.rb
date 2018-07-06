module V1
  class LessonsController < ApplicationController
    def index
      @lessons = Lesson.all
      render json: @lessons
    end

    def show
      lesson = Lesson.find(params[:id])
      render json: lesson
    end

    def create
      lesson = Lesson.create(lesson_params)
      render json: lesson
    end

    def update
      lesson = Lesson.find(params[:id])
      lesson.update!(lesson_params)
      render json: lesson
    end

    def destroy
      lesson = Lesson.find(params[:id])
      lesson.destroy
      render status: :no_content
    end

    private

    def lesson_params
      params.require(:lesson).permit(:title, :description)
    end
  end
end
