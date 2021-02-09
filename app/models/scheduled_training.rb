# frozen_string_literal: true

class ScheduledTraining < ApplicationRecord
  validates :course_name, presence: true, length: { maximum: 256 }
  validates :start_at, presence: true

  validates :instructor_name,
            presence: true,
            length: { maximum: 256 },
            uniqueness: {
              scope: :course_name,
              message: 'has already been taken for this course'
            }

  validates :duration_minutes,
            presence: true,
            numericality: {
              only_integer: true, greater_than_or_equal_to: 1,
              less_than_or_equal_to: 120
            }

  validate :overlap

  private def overlap
    return if !start_at || !duration_minutes

    is_overlap =
      ScheduledTraining.where(instructor_name: instructor_name)
        .where(
          "(start_at, start_at + (duration_minutes || ' minutes')::interval) OVERLAPS (?, ?)",
          start_at,
          start_at + duration_minutes.minutes
        ).count != 0

    errors.add(:start_at, :overlap, message: 'start_at and duration are overlaped with other') if is_overlap
  end
end
