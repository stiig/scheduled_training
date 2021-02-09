# frozen_string_literal: true

class ScheduledTraining < ApplicationRecord
  validates :instructor_name, presence: true, length: { maximum: 256 }
  validates :course_name, presence: true, length: { maximum: 256 }, uniqueness: true
  validates :start_at, presence: true
  validates :duration_minutes,
            presence: true,
            numericality: {
              only_integer: true, greater_than_or_equal_to: 1,
              less_than_or_equal_to: 120
            }

  validate :overlap

  private def overlap
    is_overlap =
      ScheduledTraining.where(instructor_name: instructor_name)
        .where(
          "(start_at, start_at + (duration_minutes || ' minutes')::interval) OVERLAPS (?, ?)",
          start_at,
          start_at + duration_minutes.minutes
        ).count != 0

    errors.add(:start_at, 'start_at and duration are overlaped with other') if is_overlap
  end
end
