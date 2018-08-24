module V1
  class OrganizationsController < ApplicationController
    before_action :authenticate_v1_user!
    before_action do
      @attributes = %i[name website]
      @allow_only_params_for = {
        create:  [organization: @attributes],
        destroy: %i[id],
        index:   [],
        show:    %i[id],
        update:  [:id, organization: @attributes]
      }
      deny_all_unpermitted_parameters
    end
    before_action :find_organization, only: %i[show update destroy]

    def index
      render json: Organization.all
    end

    def show
      render json: @organization
      # render json: LessonSerializer.new(lesson).serializable_hash[:data][:attributes]
    end

    def create
      # Choose between oneof the 2 way to write instruction (create or update)
      # lesson = current_v1_user.created_lessons.create!(create_params)
      organization = Organization.create!(create_params.merge(creator: current_v1_user))
      organization.members << current_v1_user
      # binding.pry
      render json: organization, status: :created
    end

    def update
      authorize [:v1, @organization]
      @organization.update!(update_params)
      render json: @organization
    end

    def destroy
      # Maybe destroy, see later
      # @lesson.destroy
      authorize [:v1, @organization]
      @organization.delete
      head :no_content
    end

    def pundit_user
      current_v1_user
    end

    private

    def create_params
      params.require(:organization).permit(@attributes)
    end
    alias_method :update_params, :create_params

    def find_organization
      @organization = Organization.find(params[:id])
    end
  end
end
