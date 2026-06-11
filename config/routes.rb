Rails.application.routes.draw do
  root "globe#index"
  devise_for :users
  get "/globe", to: "globe#index"

  get "up" => "rails/health#show", as: :rails_health_check
  resources :polls, only: [:index, :new, :create, :destroy, :show] do
    member do
      get :country_votes
      get :ai_summary
    end
    collection do
      get :my_polls
      get :my_votes
      get :explore
      post :ai_suggestions
    end

    resources :votes, only: [:create, :destroy]
    resources :poll_comments, only: [:create, :destroy]
  end

  resource :profile, only: [:show] do
    get :ai_summary
  end

  resources :conversations, only: [:new, :show, :create] do
    resources :chat_messages, only: [:create]
  end

  resources :user_countries, only: [:create, :destroy]

  resources :notifications, only: [:index]
end
