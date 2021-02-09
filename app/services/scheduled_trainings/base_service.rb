# frozen_string_literal: true

module ScheduledTrainings
  module BaseService

    attr_accessor :errors, :result

    def initialize
      @errors = {}
      @result = nil
    end

    def success?
      @errors.empty?
    end

  end
end
