# frozen_string_literal: true

class ApplicationController < ActionController::API

  NotAuthorizedError = Class.new(StandardError)

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: { base: 'record not found' } }, status: :not_found
  end

  rescue_from NotAuthorizedError do
    render json: { errors: { base: 'operation not allowed' } }, status: :forbidden
  end
end
