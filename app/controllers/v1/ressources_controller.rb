module V1
  class RessourcesController < ApplicationController
    before_action :authenticate_v1_user!
    before_action do
      @attributes = %i[key acl content_type]
      @allow_only_params_for = {
        # create:  [ressource: @attributes],
        # destroy: %i[id],
        # index:   %i[page page_size],
        # show:    %i[id],
        # update:  [:id, ressource: @attributes]
        request_s3: [@attributes]
      }
      deny_all_unpermitted_parameters
    end
    before_action :find_organization, only: %i[show update destroy]
    before_action :pre_signed_params, only: [:request_s3]
    def index; end

    def show; end

    def create; end

    def update; end

    def destroy; end

    def request_s3
      # para = { bucket: Rails.application.credentials.dig(:aws, :bucket),
      #          key: 'cat', acl: 'public-read', content_type: 'image/jpg' }
      # binding.pry
      uri = AwsS3Service.new.call(pre_signed_params)
      response = { data: { uri: uri } }
      render json: response
    end

    private

    def create_params
      params.require(:ressource).permit(@attributes)
    end
    alias_method :update_params, :create_params

    def find_ressource
      @ressource = Ressource.find(params[:id])
    end

    def pre_signed_params
      # binding.pry
      # p 'hello'
      params.permit(:key, :acl, :content_type)
      @pre_signed_params = {
        bucket: Rails.application.credentials.dig(:aws, :bucket),
        key: params[:key],
        acl: params[:acl],
        content_type: params[:content_type]
      }
    end
  end
end
