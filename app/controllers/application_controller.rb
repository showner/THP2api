class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :params_missing
  rescue_from ActiveRecord::RecordInvalid, with: :bad_params
  rescue_from ActionController::UnpermittedParameters, with: :unpermitted_params
  # rescue_from ActionController::UrlGenerationError, with: :no_route

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def params_missing(error)
    render json: { error: error.message }, status: :forbidden
  end

  def bad_params(error)
    render json: { error: error.record.errors.full_messages }, status: :forbidden
  end

  def unpermitted_params(error)
    render json: { error: error.message }, status: :forbidden
  end
  # def no_route(error)
  #   binding.pry
  #   render json: { error: error }, status: :forbidden
  # end
end
