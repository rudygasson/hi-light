Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :books
  resources :highlights, only: ['index', 'destroy']
  resources :tags, only: ['index']
  resources :users, only: ['show']
  get "import", to: "highlights#import"
  post "upload", to: "highlights#upload"
end
