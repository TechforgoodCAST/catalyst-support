# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations]

  root 'statics#index'

  authenticate :admin do
    resources :organisations, only: %i[index show]
    resources :tickets, only: :index
  end
end
