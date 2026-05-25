Rails.application.routes.draw do
  get "conversations/show"
  get "polls/index"
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :polls, only: [:index, :create] do
    resources :votes, only: [:create]
  end

  resources :conversations, only: [:show, :create] do
    resources :messages, only: [:create]
  end
end
