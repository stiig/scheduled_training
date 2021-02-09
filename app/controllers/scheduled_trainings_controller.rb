# frozen_string_literal: true

class ScheduledTrainingsController < ApplicationController
  before_action :set_scheduled_training, only: %i[show update destroy]

  # just for demo
  def index
    @trainings = ScheduledTraining.all

    render json: @trainings
  end

  def create
    action = ::ScheduledTrainings::CreateService.new.call(training_params)

    if action.success?
      render json: action.result
    else
      render json: { errors: action.errors }, status: :unprocessable_entity
    end
  end

  def show
    render json: @scheduled_training
  end

  def update
    action = ScheduledTrainings::UpdateService.new.call(@scheduled_training, editing_training_params)

    if action.success?
      render json: action.result
    else
      render json: { errors: action.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    @scheduled_training.destroy

    render json: @scheduled_training
  end

  def set_scheduled_training
    @scheduled_training = ScheduledTraining.find_by!(uid: params[:uid])
  end

  def training_params
    params.require(:scheduled_training).permit(:instructor_name, :course_name, :start_at, :duration_minutes)
  end

  def editing_training_params
    params.require(:scheduled_training).permit(:course_name, :start_at, :duration_minutes)
  end
end
