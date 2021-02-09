# frozen_string_literal: true

class ScheduledTrainingSerializer < ActiveModel::Serializer
  attributes :uid, :instructor_name, :course_name, :start_at, :duration_minutes
end
