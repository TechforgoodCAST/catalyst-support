# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  root 'statics#index'

  resources :organisations, only: %i[index show]
  resources :tickets, only: :index
end
