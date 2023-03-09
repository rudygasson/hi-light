Rails.application.routes.draw do
  devise_for :users
  root to: "books#index"
  resources :books
  resources :highlights, only: ['index', 'destroy']
  resources :tags, only: ['index']
  get "import", to: "highlights#import"
  post "upload", to: "highlights#upload"
end
