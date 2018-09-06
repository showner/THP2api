module V1
  class InvitationsController < ApplicationController
    before_action :authenticate_v1_user!
    before_action do
      @attributes = %i[destination_email interest_id interest_type invitee]
      @allow_only_params_for = {
        create:  [invitation: @attributes],
        destroy: %i[id],
        index:   [],
        show:    %i[id],
        update:  [:id, invitation: %i[interest_id interest_type]]
      }
      deny_all_unpermitted_parameters
    end
    before_action :find_invitation, only: %i[show update destroy]

    def index; end

    def show
      render json: @invitation
      # render json: LessonSerializer.new(lesson).serializable_hash[:data][:attributes]
    end

    def create
      # Choose between oneof the 2 way to write instruction (create or update)
      # lesson = current_v1_user.created_lessons.create!(create_params)
      invitation = Invitation.create!(create_params.merge(emitter: current_v1_user))
      # binding.pry
      render json: invitation, status: :created
    end

    def update
      # authorize [:v1, @invitation]
      @invitation.update!(update_params)
      render json: @invitation
    end

    def destroy
      # authorize [:v1, @invitation]
      @invitation.destroy
      head :no_content
    end

    private

    def create_params
      params.require(:invitation).permit(@attributes)
    end
    alias_method :update_params, :create_params

    def find_invitation
      @invitation = Invitation.find(params[:id])
    end
  end
end
