Rails.application.routes.draw do
  root "globe#index"
  devise_for :users
  get "/globe", to: "globe#index"

  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found",              via: :all
  match "/500", to: "errors#internal_server_error",  via: :all
  post '/create_ai_conversation', to: 'conversations#create_ai_conversation', as: 'create_ai_conversation'
  post 'polls/:poll_id/create_ai_conversation_with_poll_context', to: 'conversations#create_ai_conversation_with_poll_context', as: 'create_ai_conversation_with_poll_context'
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
