Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check
  resources :polls, only: [:index, :new, :create, :destroy] do
    collection do
      get :my_polls
      get :my_votes
    end
    resources :votes, only: [:create, :destroy]
  end

  resource :profile, only: [:show]

  resources :conversations, only: [:new, :show, :create] do
    resources :chat_messages, only: [:create]
  end
end
