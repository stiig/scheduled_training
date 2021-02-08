# frozen_string_literal: true

Rails.application.routes.draw do
  resources :scheduled_trainings, param: :uid
end
