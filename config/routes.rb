Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :polls, only: [:index, :new, :create] do
    resources :votes, only: [:create]
  end

  resources :conversations, only: [:new, :show, :create] do
    resources :chat_messages, only: [:create]
  end
end
