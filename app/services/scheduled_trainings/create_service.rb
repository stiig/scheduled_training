# frozen_string_literal: true

module ScheduledTrainings
  class CreateService
    include BaseService

    def call(params)
      @result = ScheduledTraining.new(params)

      if result.valid?
        result.save
        result.reload
      else
        errors.merge!(result.errors)
      end

      self
    end

  end
end
