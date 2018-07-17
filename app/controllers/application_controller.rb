class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::ParameterMissing, with: :params_missing
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record

  def record_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def params_missing(error)
    render json: { error: error.message }, status: :forbidden
  end

  def invalid_record(error)
    render json: { error: error.message }, status: :forbidden
  end
end
