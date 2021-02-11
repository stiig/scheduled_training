# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledTraining do
  describe 'validations' do
    it 'check for presence and default' do
      training = ScheduledTraining.create

      expect(training.errors).not_to be_empty
      expect(training.errors).to include(:instructor_name, :course_name, :start_at)
      expect(training.duration_minutes).to be(30)
    end

    it 'check for unique course_name and instructor_name' do
      params = {
        instructor_name: 'Bob',
        course_name: 'SQL',
        start_at: Time.current,
        duration_minutes: 1
      }

      ScheduledTraining.create(params)
      training = ScheduledTraining.create(params.merge(start_at: Time.current + 5.minutes))

      expect(training.errors).not_to be_empty
      expect(training.errors).to include(:instructor_name)
      expect(training.errors.first.type).to be(:taken)
    end

    it 'check for overlap' do
      params = {
        instructor_name: 'Bob',
        start_at: Time.current,
      }

      ScheduledTraining.create(params.merge(course_name: 'SQL', duration_minutes: 120))
      training = ScheduledTraining.create(params.merge(course_name: 'Unix', duration_minutes: 5))

      expect(training.errors).not_to be_empty
      expect(training.errors).to include(:start_at)
      expect(training.errors.first.type).to be(:overlap)
    end

    it 'check for limits' do
      long_string = 'a' * 300

      training = ScheduledTraining.create(
        instructor_name: long_string,
        course_name: long_string,
        duration_minutes: 300,
        start_at: Time.current
      )

      training2 = ScheduledTraining.create(
        instructor_name: long_string,
        course_name: long_string,
        duration_minutes: 0,
        start_at: Time.current
      )

      expect(training.errors).not_to be_empty
      expect(training.errors).to include(:instructor_name, :course_name, :duration_minutes)
      expect(training.errors.of_kind?(:course_name, :too_long)).to be(true)
      expect(training.errors.of_kind?(:instructor_name, :too_long)).to be(true)
      expect(training.errors.of_kind?(:duration_minutes, :less_than_or_equal_to)).to be(true)

      expect(training2.errors.of_kind?(:duration_minutes, :greater_than_or_equal_to)).to be(true)
    end
  end
end
