Rails.application.routes.draw do
  devise_for :users
  root to: "books#index"
  resources :books
  resources :highlights, only: ["index"]
end
