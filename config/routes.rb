Rails.application.routes.draw do
  devise_for :users
  root to: "books#index"
  resources :books
  get "import", to: "highlights#import"
  post "upload", to: "highlights#upload"
end
