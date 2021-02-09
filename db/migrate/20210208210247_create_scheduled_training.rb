# frozen_string_literal: true

class CreateScheduledTraining < ActiveRecord::Migration[6.1]
  def change
    create_table :scheduled_trainings do |t|
      t.column   :uid, :uuid, null: false, index: { unique: true }, default: 'gen_random_uuid()'

      t.string   :instructor_name, null: false, limit: 256, index: true
      t.string   :course_name, null: false, limit: 256, index: { unique: true }
      t.datetime :start_at, null: false
      t.integer  :duration_minutes, null: false, default: 30

      t.timestamps
    end
  end
end
