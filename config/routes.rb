# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins, skip: [:registrations], controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }

  root 'statics#index'

  authenticate :admin do
    resources :organisations, only: %i[index show]
  end
end
