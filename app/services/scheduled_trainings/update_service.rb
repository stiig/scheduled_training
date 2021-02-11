# frozen_string_literal: true

module ScheduledTrainings
  class UpdateService
    include BaseService

    def call(item, params)
      @result = item

      # can later be replaced with pundit
      authorize(item, params)

      if result.update(params)
        result
      else
        errors.merge!(result.errors)
      end

      self
    end

    def authorize(item, params)
      raise ApplicationController::NotAuthorizedError if item.instructor_name != params[:instructor_name]
    end
  end
end
