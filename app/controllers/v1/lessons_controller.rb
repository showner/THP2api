module V1
  class LessonsController < ApplicationController
    before_action :authenticate_v1_user!
    before_action do
      @attributes = %i[title description]
      @allow_only_params_for = {
        create:  [lesson: @attributes],
        destroy: [:id],
        index:   [],
        show:    [:id],
        update:  [:id, lesson: @attributes]
      }
      deny_all_unpermitted_parameters
    end
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
      # Choose between oneof the 2 way to write instruction (create or update)
      # lesson = current_v1_user.created_lessons.create!(create_params)
      lesson = Lesson.create!(create_params.merge(creator: current_v1_user))
      render json: lesson, status: :created
    end

    def update
      authorize [:v1, @lesson]

      @lesson.update!(update_params)
      render json: @lesson
    end

    def destroy
      # Maybe destroy, see later
      # @lesson.destroy
      authorize [:v1, @lesson]
      @lesson.delete
      head :no_content
    end

    def pundit_user
      current_v1_user
    end

    private

    def create_params
      params.require(:lesson).permit(@attributes)
    end
    alias_method :update_params, :create_params

    def deny_all_unpermitted_parameters
      ActionController::Parameters.action_on_unpermitted_parameters = :raise
      params.permit(*@allow_only_params_for[params[:action].to_sym])
    end

    def find_lesson
      @lesson = Lesson.find(params[:id])
    end
  end
end
