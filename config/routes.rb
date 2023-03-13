Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :books
  resources :highlights, only: ['index', 'destroy', 'update']
  resources :tags, only: ['index', 'new', 'create', 'edit', 'update', 'destroy']
  resources :users, only: ['show', 'index']
  get "import", to: "highlights#import"
  post "upload", to: "highlights#upload"
end
