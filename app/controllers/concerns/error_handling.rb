# frozen_string_literal: true

# Provides standardized error handling for controllers
module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :handle_record_invalid
    rescue_from ActionController::ParameterMissing, with: :handle_parameter_missing
  end

  private

  def handle_not_found(exception)
    model_name = exception.model&.underscore&.humanize || 'Record'
    respond_to do |format|
      format.html { redirect_back_or_to(root_path, alert: "#{model_name} not found.") }
      format.json { render json: { error: "#{model_name} not found" }, status: :not_found }
    end
  end

  def handle_record_invalid(exception)
    respond_to do |format|
      format.html do
        flash.now[:alert] = exception.record.errors.full_messages.to_sentence
        render :new, status: :unprocessable_content
      end
      format.json { render json: { errors: exception.record.errors }, status: :unprocessable_content }
    end
  end

  def handle_parameter_missing(exception)
    respond_to do |format|
      format.html { redirect_back_or_to(root_path, alert: "Missing parameter: #{exception.param}") }
      format.json { render json: { error: "Missing parameter: #{exception.param}" }, status: :bad_request }
    end
  end
end
