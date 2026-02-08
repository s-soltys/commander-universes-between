Rails.application.routes.draw do
  root "decks#new"

  resources :decks, only: [:new, :create, :show]

  get "up" => "rails/health#show", as: :rails_health_check
end
