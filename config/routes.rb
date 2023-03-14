Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  resources :books
  resources :highlights, only: ['index', 'destroy', 'update'] do
    resources :hi_tags, only: ['new', 'create']
  end
  resources :tags, only: ['index', 'new', 'create', 'edit', 'update', 'destroy', 'destroy_all']
  resources :users, only: ['show', 'index'] do
    resources :books, only: ['show'], as: "friend_books"
  end

  get "friends/:id", to: "users#friends_profile", as: "friend"
  get "import", to: "highlights#import"
  post "upload", to: "highlights#upload"

  get "dashboard", to: "users#dashboard"
  get "manage", to: "books#manage"
  get "tags/manage", to: "tags#manage"
  get "friends/:id/books/:id", to: "books#friends_show", as: "friend_books"

  patch "follow/:id", to: "users#follow", as: "follow"
  patch "book/:id/cover", to: "books#set_parsed_cover", as: "parse_cover"
  patch "book/:id/random-cover", to: "books#random_cover", as: "random_cover"
end
