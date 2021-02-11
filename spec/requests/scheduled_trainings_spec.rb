# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ScheduledTrainingsController' do
  describe 'POST /scheduled_trainings' do
    let(:training) { generate_training }

    it 'can create a record' do
      post(
        scheduled_trainings_path,
        params: {
          scheduled_training: {
            instructor_name: 'Bob',
            course_name: 'SQL',
            duration_minutes: 20,
            start_at: Time.current,
          },
        })

      expect(parse_json(response.body)).to include(:uid, :instructor_name, :course_name, :start_at, :duration_minutes)
    end

    it "can't create overlapped training" do
      training

      post(
        scheduled_trainings_path,
        params: {
          scheduled_training: {
            instructor_name: 'Bob',
            course_name: 'ML',
            duration_minutes: 20,
            start_at: Time.current,
          },
        })

      expect(parse_json(response.body)).to include({ errors: { start_at: ["start_at and duration are overlaped with other"] } })
    end
  end

  context 'interaction with item' do
    describe 'GET /scheduled_trainings/:uid' do
      it 'can show record by uid' do
        get(scheduled_training_path(generate_training.uid))

        expect(parse_json(response.body)).to include(:uid, :instructor_name, :course_name, :start_at, :duration_minutes)
      end
    end

    describe 'PUT /scheduled_trainings/:uid' do
      let(:new_time) { (Time.current + 30.minutes).to_s(:db) }
      let(:training) { generate_training }

      it 'can update record with the same instructor_name by uid' do
        new_time = (training.start_at + 30.minutes).to_s(:db)

        put(
          scheduled_training_path(training.uid),
          params: {
            scheduled_training: {
              instructor_name: 'Bob',
              course_name: 'SQL',
              start_at: new_time,
            },
          },
        )

        expect(response).to have_http_status(:success)
        expect(training.reload.start_at).to eq(new_time)
      end

      it "can't update with different instructor_name" do
        put(
          scheduled_training_path(training.uid),
          params: {
            scheduled_training: {
              instructor_name: 'Jack',
              course_name: 'SQL',
              start_at: new_time,
            },
          },
        )

        expect(response).to have_http_status(:forbidden)
        expect(parse_json(response.body)).to include({ errors: { base: 'operation not allowed' } })
      end
    end

    describe 'DELETE /scheduled_trainings/:uid' do
      let(:training) { generate_training }

      it 'can delete by uid' do
        delete(scheduled_training_path(training.uid))

        expect(response).to have_http_status(:success)
        expect { training.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  def parse_json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def generate_training
    ScheduledTraining
      .create(
        instructor_name: 'Bob',
        course_name: 'SQL',
        duration_minutes: 20,
        start_at: Time.current,
      )
      .reload
  end
end
