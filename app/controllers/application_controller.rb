# frozen_string_literal: true

class ApplicationController < ActionController::API

  rescue_from ActiveRecord::RecordNotFound do
    render json: { errors: { base: 'record not found' } }, status: :not_found
  end
end
