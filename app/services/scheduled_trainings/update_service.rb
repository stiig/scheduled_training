# frozen_string_literal: true

module ScheduledTrainings
  class UpdateService
    include BaseService

    def call(item, params)
      @result = item

      if result.update(params)
        result
      else
        errors.merge!(result.errors)
      end

      self
    end
  end
end
